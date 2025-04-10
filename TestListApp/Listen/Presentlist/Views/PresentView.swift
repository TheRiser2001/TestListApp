//
//  GeschenkeView.swift
//  TestListApp
//
//  Created by Michael Ilic on 26.03.24.
//

import SwiftUI


struct PresentView: View {
    @State private var people: [PresentPerson] = [
        PresentPerson(name: "Mama", items: [PresentItem(name: "Gartenzwerg", status: .unterwegs, price: 200, showDate: false, date: Date.now), PresentItem(name: "Blumentopf", status: .ueberlegung, price: 50, showDate: false, date: Date.now), PresentItem(name: "Test", status: .unmöglich, price: 100, showDate: false, date: Date.now), PresentItem(name: "Irgendwas", status: .ueberlegung, price: 0, showDate: false, date: Date.now)]),
        PresentPerson(name: "Papa", items: [PresentItem(name: "Auto", status: .unmöglich, price: 100, showDate: false, date: Date.now)]),
        PresentPerson(name: "Tina", items: [PresentItem(name: "Buch", status: .ueberlegung, price: 10, showDate: false, date: Date.now)]),
        PresentPerson(name: "Michi", items: [PresentItem(name: "MacBook Air", status: .besorgt, price: 5000, showDate: false, date: Date.now)])
    ]
//    let listInfo: ListInfo
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    LazyVGrid(columns: Array(repeating: GridItem(), count: 2)) {
                        ForEach(people) { person in
                            RectangleView(person: person,
                                          deletePerson: {
                                if let index = people.firstIndex(where: { $0.id == person.id }) {
                                    people.remove(at: index)
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
                            let newPerson = PresentPerson(name: "Test", items: [PresentItem(name: "Test", status: .ueberlegung, price: 0, showDate: false, date: Date.now)])
                            people.append(newPerson)
                        } label: {
                            Image(systemName: "plus.circle")
                        }
                    }
                }
                
                .toolbarBackground(Color.pink.opacity(0.6), for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
            }
        }
    }
}

struct RectangleView: View {
    
    @ObservedObject var person: PresentPerson
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
                        PresentDetailView(person: person, deletePerson: deletePerson)
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

struct PresentDetailView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var deletePersonAlert: Bool = false
    @State private var arrivedProducts: Bool = false
    @State private var showArrivedAlert: Bool = false
    @State private var showDeleteAlert: Bool = false
    
    @ObservedObject var person: PresentPerson
    var deletePerson: () -> Void
    
    var body: some View {
        Form {
            Section("Für wen ist das Geschenk?") {
                TextField("Name", text: $person.name)
                    .bold()
            }
            
            PresentItemRow(person: person)
            
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
                    let newItem = PresentItem(name: "Neues Geschenk", status: .ueberlegung, price: 10, showDate: false, date: Date.now)
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

struct PresentItemRow: View {
    
    @State private var anzahlItems: Int = 0
    
    @ObservedObject var person: PresentPerson
      
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
                    TextField("0", value: $person.items[index].price, formatter: NumberFormatter())
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
    
    @ObservedObject var person: PresentPerson
    
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
    PresentView()
}
