//
//  GeschenkeView.swift
//  TestListApp
//
//  Created by Michael Ilic on 26.03.24.
//

import SwiftUI


struct PresentView: View {
    @Environment(\.dismiss) var dismiss
    
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
                    
                    ToolbarItem(placement: .topBarLeading) {
                        Button { dismiss } label: {
                            Image(systemName: "xmark.circle")
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

#Preview {
    PresentView()
}
