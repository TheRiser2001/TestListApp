//
//  PresentDetailView.swift
//  TestListApp
//
//  Created by Michael Ilic on 11.04.25.
//

import SwiftUI

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

//#Preview {
//    PresentDetailView(person: PresentPerson(name: "Tina", items: [PresentItem(name: "Buch", status: .besorgt, price: 30, showDate: false, date: Date())]), deletePerson: <#() -> Void#>)
//}
