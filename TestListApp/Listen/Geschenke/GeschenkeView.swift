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

class GeschenkItem: Identifiable {
    let id = UUID()
    @Published var name: String
    @Published var status: Status
    @Published var preis: Int
    
    init(name: String, status: Status, preis: Int) {
        self.name = name
        self.status = status
        self.preis = preis
    }
}

enum Status: CaseIterable, Comparable {
    case besorgt
    case unterwegs
    case ueberlegung
    case unmöglich
    
    var asString: String {
        "\(self)".capitalized
    }
    
    var color: Color {
        switch self {
        case .besorgt: return .green
        case .unterwegs: return .blue
        case .ueberlegung: return .yellow
        case .unmöglich: return .red
        }
    }
}

struct GeschenkeView: View {
    @State private var personen: [GeschenkPerson] = [
        GeschenkPerson(name: "Mama", items: [GeschenkItem(name: "Gartenzwerg", status: .unterwegs, preis: 200), GeschenkItem(name: "Blumentopf", status: .ueberlegung, preis: 50)]),
        GeschenkPerson(name: "Papa", items: [GeschenkItem(name: "Auto", status: .unmöglich, preis: 100)]),
        GeschenkPerson(name: "Tina", items: [GeschenkItem(name: "Buch", status: .ueberlegung, preis: 10)]),
        GeschenkPerson(name: "Michi", items: [GeschenkItem(name: "MacBook Air", status: .besorgt, preis: 5000)])
    ]
    let listInfo: ListInfo
    
    var body: some View {
        NavigationStack {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                    ForEach(personen) { person in
                        RectangleView(person: person)
                    }
            }
            .padding()
            
            .navigationTitle("Geschenke")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        let newPerson = GeschenkPerson(name: "Test", items: [GeschenkItem(name: "Test", status: .ueberlegung, preis: 0)])
                        personen.append(newPerson)
                    }) {
                        Image(systemName: "plus.circle")
                    }
                }
            }
            
            .toolbarBackground(listInfo.backgroundColor.opacity(0.6), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}



struct RectangleView: View {
    
    @ObservedObject var person: GeschenkPerson
    
    var body: some View {
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 10.0)
                .stroke()
            
            VStack(alignment: .center) {
                LazyVGrid(columns: [GridItem(alignment: .leading), GridItem(alignment: .trailing)]) {
                    
                    Text(person.name)
                        .bold()
                    
                    NavigationLink {
                        GeschenkeDetailView(personName: $person.name, items: $person.items)
                    } label: {
                        Image(systemName: "info.circle")
                    }
                }
                .padding(.top)
                .padding(.horizontal, 8)
                Divider()
                
                ForEach(person.items) { item in
                    HStack {
                        Text(item.name)
                            .foregroundStyle(item.status.color)
                        Spacer()
                    }
                    .padding(.horizontal, 8)
                    Divider()
                }
                
                Button(action: {  
                    let newItem = GeschenkItem(name: "Testitem", status: .ueberlegung, preis: 10)
                    withAnimation {
                        person.items.append(newItem)
                    }
                }) {
                    HStack {
                        Image(systemName: "plus")
                        Text("Hinzufügen")
                    }
                }
                .padding(.bottom)
            }
        }
    }
}

struct GeschenkeDetailView: View {
    
    @State private var anzahlItems: Int = 0
    @State private var showArrivedAlert: Bool = false
    @State private var showDeleteAlert: Bool = false
    @State private var preisTextField: String = ""
    
    @Binding var personName: String
    @Binding var items: [GeschenkItem]
    
    
    var body: some View {
        Form {
            Section("Für wen ist das Geschenk?") {
                TextField("Name", text: $personName)
                    .bold()
            }
            
            ForEach(items.indices, id: \.self) { index in
                let item = items[index]
                
                Section("Produkt \(anzahlItems + index + 1)") {
                    
                    HStack {
                        Text("Produkt:")
                        Spacer()
                        //Text(item.name)
                        TextField("Produktname", text: $items[index].name)
                            .frame(width: 200)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    Picker("Status:", selection: $items[index].status) {
                        ForEach(Status.allCases, id: \.self) { status in
                            Text(status.asString).tag(status)
                        }
                    }
                    .pickerStyle(.menu)
                    .accentColor(item.status.color)
                    
                    HStack {
                        Text("Preis:")
                        Spacer()
                        TextField("0", text: $preisTextField)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.numberPad)
                        Text("€")
                    }
                    
                    LazyVGrid(columns: [GridItem(), GridItem()]) {
                        Button(action: {
                            showArrivedAlert = true
                        }, label: {
                            Text("Produkt angekommen")
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.green)
                        })
                        .buttonStyle(BorderlessButtonStyle())
                        
                        Button(action: {
                            showDeleteAlert = true
                        }, label: {
                            Text("Produkt löschen")
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.red)
                        })
                        .buttonStyle(BorderlessButtonStyle())
                        
                    }
                }
            }
            
            Section {
                
                Button("Produkt hinzufügen") {
                    let newItem = GeschenkItem(name: "Testitem", status: .ueberlegung, preis: 10)
                    withAnimation {
                        items.append(newItem)
                    }
                }
                
                Button(action: {}, label: {
                    Text("Angekommene Produkte")
                })
                
                Button("Person löschen", role: .destructive) {
                    
                }
            }
            //.frame(maxWidth: .infinity)
        }
        .alert("Produkt angekommen?", isPresented: $showArrivedAlert) {
            Button("Abbrechen") {
                
            }
            
            Button(action: {}, label: {
                Text("Angekommen")
                    .bold()
            })
            
        } message: {
            Text("Sie können diese Produkte jederzeit erneut einsehen und wiederherstellen.")
        }
        
        .alert("Produkt löschen?", isPresented: $showDeleteAlert) {
            Button("Behalten", role: .cancel) {
                
            }
            
            Button("Löschen", role: .destructive) {
                
            }
            
        } message: {
            Text("Bist du dir sicher das du dieses Produkt löschen möchtest?")
        }
        
    }
}

struct EditItemRowView: View {
    
    var body: some View {
        Text("Hi")
    }
}

#Preview {
    GeschenkeView(listInfo: ListInfo(listName: "", backgroundColor: .blue, accentColor: .white))
}

#Preview {
    GeschenkeDetailView(personName: .constant("Mama"), items: .constant([GeschenkItem(name: "Test6789", status: .besorgt, preis: 50), GeschenkItem(name: "Test12345", status: .unterwegs, preis: 10)]))
}
