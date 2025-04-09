//
//  GeschenkeView.swift
//  TestListApp
//
//  Created by Michael Ilic on 26.03.24.
//

import SwiftUI

class GeschenkPerson: ObservableObject, Identifiable {
    let id = UUID()
    @Published var name: String
    @Published var items: [GeschenkItem]
    
    init(name: String, items: [GeschenkItem]) {
        self.name = name
        self.items = items
    }
}

class GeschenkItem: ObservableObject, Identifiable {
    let id = UUID()
    @Published var name: String
    @Published var status: Status
    @Published var preis: Int
    @Published var showDate: Bool
    @Published var date: Date
    
    init(name: String, status: Status, preis: Int, showDate: Bool, date: Date) {
        self.name = name
        self.status = status
        self.preis = preis
        self.showDate = showDate
        self.date = date
    }
}

enum Status: CaseIterable, Comparable {
    case besorgt
    case unterwegs
    case ueberlegung
    case unmöglich
    
    var asString: String {
        switch self {
        case .ueberlegung: return "Überlegung"
        default: return "\(self)".capitalized
        }
    }
    
    var color: Color {
        switch self {
        case .besorgt: return .green
        case .unterwegs: return .blue
        case .ueberlegung: return .orange
        case .unmöglich: return .red
        }
    }
}

struct GeschenkeView: View {
    @State private var personen: [GeschenkPerson] = [
        GeschenkPerson(name: "Mama", items: [GeschenkItem(name: "Gartenzwerg", status: .unterwegs, preis: 200, showDate: false, date: Date.now), GeschenkItem(name: "Blumentopf", status: .ueberlegung, preis: 50, showDate: false, date: Date.now), GeschenkItem(name: "Test", status: .unmöglich, preis: 100, showDate: false, date: Date.now), GeschenkItem(name: "Irgendwas", status: .ueberlegung, preis: 0, showDate: false, date: Date.now)]),
        GeschenkPerson(name: "Papa", items: [GeschenkItem(name: "Auto", status: .unmöglich, preis: 100, showDate: false, date: Date.now)]),
        GeschenkPerson(name: "Tina", items: [GeschenkItem(name: "Buch", status: .ueberlegung, preis: 10, showDate: false, date: Date.now)]),
        GeschenkPerson(name: "Michi", items: [GeschenkItem(name: "MacBook Air", status: .besorgt, preis: 5000, showDate: false, date: Date.now)])
    ]
    let listInfo: ListInfo
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    LazyVGrid(columns: Array(repeating: GridItem(), count: 2)) {
                        ForEach(personen) { person in
                            RectangleView(person: person,
                                          deletePerson: {
                                if let index = personen.firstIndex(where: { $0.id == person.id }) {
                                    personen.remove(at: index)
                                }
                            })
                        }
                    }
                    .padding(15)
                }
                .navigationTitle("Geschenke")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            let newPerson = GeschenkPerson(name: "Test", items: [GeschenkItem(name: "Test", status: .ueberlegung, preis: 0, showDate: false, date: Date.now)])
                            personen.append(newPerson)
                        } label: {
                            Image(systemName: "plus.circle")
                        }
                    }
                }
                
                .toolbarBackground(listInfo.backgroundColor.opacity(0.6), for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
            }
        }
    }
}

struct RectangleView: View {
    
    @ObservedObject var person: GeschenkPerson
    var deletePerson: () -> Void
    
    var body: some View {
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(red: 250/255, green: 243/255, blue: 224/255))
                .frame(height: 190)
            
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    Text(person.name)
                        .bold()
                    
                    NavigationLink {
                        GeschenkeDetailView( person: person, deletePerson: deletePerson)
                    } label: {
                        Image(systemName: "info.circle")
                    }
                    .hAlign(.trailing)
                }
                .padding(.top)
                .padding(.horizontal, 8)
                
                Divider()
                
                // - Dank .prefix(3) kann ich angeben, dass maximal 3 Items angezeigt werden sollen
                ForEach(person.items.prefix(3)) { item in
                    HStack {
                        Text(item.name)
                            .foregroundStyle(item.status.color)
                    }
                    Divider()
                }
                    .foregroundStyle(.blue)
                    .padding(.leading, 8)
                
                if person.items.count > 3 {
                    let newCount = person.items.count - 3
                    Text(newCount == 1 ? "\(newCount) weiteres Geschenk..." : "\(newCount) weitere Geschenke")
                        .font(.caption)
                        .padding(.leading, 8)
                        .foregroundStyle(.gray)
                }
            }
        }
    }
}

struct GeschenkeDetailView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var deletePersonAlert: Bool = false
    @State private var arrivedProducts: Bool = false
    @State private var showArrivedAlert: Bool = false
    @State private var showDeleteAlert: Bool = false
    
    @ObservedObject var person: GeschenkPerson
    var deletePerson: () -> Void
    
    var body: some View {
        Form {
            Section("Für wen ist das Geschenk?") {
                TextField("Name", text: $person.name)
                    .bold()
            }
            
            GeschenkItemRow(person: person)
            
            Section {
                Button("Angekommene Produkte") {
                    arrivedProducts.toggle()
                }
                
                Button("Person löschen", role: .destructive) {
                    deletePersonAlert.toggle()
                }
            }
        }
        
        .sheet(isPresented: $arrivedProducts) {
            ArrivedProducts(person: person)
                .presentationDetents([.fraction(0.5)])
        }
        
        .alert("Produkt angekommen?", isPresented: $showArrivedAlert) {
            showArrivedProductsButton()
        } message: {
            Text("Sie können diese Produkte jederzeit erneut einsehen und wiederherstellen.")
        }
        
        .alert("Produkt löschen?", isPresented: $showDeleteAlert) {
            Button("Löschen", role: .destructive) {
//                deleteProduct()
            }
        } message: {
            Text("Bist du dir sicher das du dieses Produkt löschen möchtest?")
        }
        
        .alert("Person löschen?", isPresented: $deletePersonAlert) {
            Button("Ja", role: .destructive) {
                deletePerson()
                dismiss()
            }
        } message: {
            Text("Bist du sicher das du diese Person endgültig löschen möchtest? Dieser Vorgang kann nicht widerhergestellt werden")
        }
        
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    let newItem = GeschenkItem(name: "Neues Geschenk", status: .ueberlegung, preis: 10, showDate: false, date: Date.now)
                    withAnimation {
                        person.items.append(newItem)
                    }
                } label: {
                    Text("Produkt")
                    Image(systemName: "plus")
                }
            }
        }
    }
    
//    private func deleteProduct() {
//        if let itemToDelete = itemToDelete, let index = items.firstIndex(where: { $0.id == itemToDelete.id }) {
//            items.remove(at: index)
//        }
//    }
    
    @ViewBuilder
    private func showArrivedProductsButton() -> some View {
        Button("Abbrechen", role: .cancel) {}
        
        Button {
//            if let index = person.items.firstIndex(where: { $0.id == item.id}) {
//                person.items[index].status = .besorgt
//            }
        } label: {
            Text("Angekommen")
        }
    }
}

struct GeschenkItemRow: View {
    
    @State private var anzahlItems: Int = 0
    
    @ObservedObject var person: GeschenkPerson
      
    var body: some View {
        ForEach(person.items.indices, id: \.self) { index in
            let item = person.items[index]
            
            Section("Produkt \(anzahlItems + index + 1)") {
                
                HStack {
                    Text("Produkt:")
                    Spacer()
                    TextField("Produktname", text: $person.items[index].name)
                        .frame(width: 200)
                        .multilineTextAlignment(.trailing)
                }
                
                Picker("Status:", selection: $person.items[index].status) {
                    ForEach(Status.allCases, id: \.self) { status in
                        Text(status.asString).tag(status)
                    }
                }
                .pickerStyle(.menu)
                .accentColor(item.status.color)
                
                HStack {
                    Text("Preis:")
                    Spacer()
                    TextField("0", value: $person.items[index].preis, formatter: NumberFormatter())
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.numberPad)
                    Text("€")
                }
                
                HStack {
                    Toggle("Zieldatum", isOn: $person.items[index].showDate)
                }
                
                if person.items[index].showDate {
                    DatePicker("Bis wann?", selection: $person.items[index].date, displayedComponents: .date)
                }
                
                LazyVGrid(columns: [GridItem(), GridItem()]) {
                    Button {
                        
                    } label: {
                        Text("Produkt angekommen")
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.green)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    
                    Button(action: {
                        
                    }, label: {
                        Text("Produkt löschen")
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.red)
                    })
                    .buttonStyle(BorderlessButtonStyle())
                    
                }
            }
        }
    }
}

struct ArrivedProducts: View {
    
    @State private var alertReturn: Bool = false
    
    @ObservedObject var person: GeschenkPerson
    
    var body: some View {
        Form {
            Section("Angekommene Produkte") {
                ForEach(person.items) { item in
                    HStack {
                        Text(item.name)
                        Spacer()
                        Button {
                            
                        } label: {
                            Image(systemName: "return")
                        }
                    }
                }
                HStack {
                    Text("Was geht")
                    Spacer()
                    Button {
                        alertReturn.toggle()
                    } label: {
                        Image(systemName: "return")
                    }
                }
            }
        }
        .alert("Produkt wiederherstellen?", isPresented: $alertReturn) {
            Button("Nein") {}
            Button("Ja") {}
        } message: {
            Text("Willst du diesen Artikel wiederherstellen und ihn somit wieder in der Liste haben?")
        }
    }
}

#Preview {
    GeschenkeView(listInfo: ListInfo(listName: "", systemName: "cart", itemsName: "Irgendwas", backgroundColor: .blue, accentColor: .white))
}
