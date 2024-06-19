//
//  Todolist.swift
//  TestListApp
//
//  Created by Michael Ilic on 25.03.24.
//

import SwiftUI
import SwiftData

////@Model
//class Person: Identifiable, ObservableObject {
//    let id = UUID()
//    @Published var name: String
//    @Published var item: [TodolistItem]
//    
//    init(name: String, item: [TodolistItem]) {
//        self.name = name
//        self.item = item
//    }
//}
//
//@Model
//class TodolistItem: Identifiable, ObservableObject {
//    let id = UUID()
//    var todoName: String
//    var priority: String
//    
//    init(todoName: String, priority: String) {
//        self.todoName = todoName
//        self.priority = priority
//    }
//}

struct Todolist: View {
    @Environment(\.modelContext) var context
//    @State private var personen: [Person] = [
//        Person(name: "Michi", item: [
//            TodolistItem(todoName: "Reifenwechsel", priority: "Niedrig"),
//            TodolistItem(todoName: "Büro gehen", priority: "Dringend!"),
//            TodolistItem(todoName: "Irgendwas", priority: "Mittel")
//        ].sorted { $0.priority < $1.priority }),
//        Person(name: "Tina", item: [
//            TodolistItem(todoName: "Haushalt", priority: "Dringend!")
//        ])
//    ]
    @Query var personen: [Person]
    
    @State private var priority: [Priority] = [.niedrig, .mittel, .hoch, .dringend]
    @State private var personIdWithoutItems: UUID?
    @State private var addSheet: Bool = false
    @State private var showAlert: Bool = false
    
    let navTitle: String
    let listInfo: ListInfo
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                List {
                    ForEach(personen.indices, id: \.self) { index in
                        SectionRowView(personIdWithoutItems: $personIdWithoutItems, priority: priority, person: personen[index])
                    }
                }
                .listStyle(.sidebar)
                .onChange(of: personIdWithoutItems) { _, newVal in
                    if newVal != nil {
                        showAlert = true
                    }
                }
                
                if personen.isEmpty {
                    EmptyStateView(sfSymbol: "star.fill", message: "Du hast alle deine Aufgaben erledigt.")
                }
            }
            .alert("Person löschen?", isPresented: $showAlert) {
                Button("Behalten", role: .cancel) {
                    personIdWithoutItems = nil
                }
                Button("Löschen", role: .destructive) {
                    if let index = personen.firstIndex(where: { $0.id == personIdWithoutItems }) {
//                        personen.remove(at: index)
                        context.delete(personen[index])
                    }
                    personIdWithoutItems = nil
                }
            } message: {
                Text("Alle Aufgaben wurden erledigt. Möchtest du die Person aus der Lsite entfernen?")
            }
        }
        .navigationTitle(navTitle)
        .navigationBarItems(trailing:
                                Button(action: { addSheet.toggle() }, label: {
            Image(systemName: "plus.circle")
        })
        )
        
        .sheet(isPresented: $addSheet) {
            AddTodoSectionView(personen: personen)
//                .presentationDetents([.fraction(0.6)])
        }
        
        .toolbarBackground(listInfo.backgroundColor.opacity(0.6), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}

struct SectionRowView: View {
    @Environment (\.modelContext) var context
    
    @State private var isExpanded: Bool = true
    
    @Binding var personIdWithoutItems: UUID?
    let priority: [Priority]
    
    @ObservedObject var person: Person
    
    var body: some View {
        
        Section(isExpanded: $isExpanded) {
            ForEach(person.item) { item in
                HStack {
                    TodoRowView(item: item, person: person, priority: priority)
                }
            }
            .onDelete { offSet in
                person.item.remove(atOffsets: offSet)
                if person.item.isEmpty {
                    personIdWithoutItems = person.id
                }
            }
            
            Button {
                let newItem = TodolistItem(todoName: "", priority: "Niedrig")
                withAnimation {
//                    context.insert(newItem)
                    person.item.append(newItem)
                }
            } label: {
                HStack {
                    Image(systemName: "plus")
                    Text("Neues Todo hinzufügen")
                }
                .foregroundStyle(.blue)
            }
            
        } header: {
            Text(person.name)
        }
    }
}

struct TodoRowView: View {
    
    @State private var isDone: Bool = false
    
    @State private var editSheet: Bool = false
    
    @ObservedObject var item: TodolistItem
    @ObservedObject var person: Person
    
    let priority: [Priority]
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    guard item.todoName != "" else { return }
                    withAnimation {
                        isDone.toggle()
                    }
                }, label: {
                    Image(systemName: isDone ? "checkmark.circle.fill" : "checkmark.circle")
                        .foregroundStyle(isDone ? .green : .red)
                })
                
                TextField("Todo eintragen", text: $item.todoName)
                    .strikethrough(isDone ? true : false)
                    .foregroundStyle(isDone ? Color.gray.opacity(0.7) : Color.primary)
                Spacer()
                
//                Menu(item.priority) {
//                    ForEach(Priority.allCases, id: \.self) { prio in
//                        Button(prio.asString) {
//                            item.priority = prio.asString
//                        }
//                    }
//                }
//                .foregroundStyle(priority.color)
                

                if item.priority == "Niedrig" {
                    Menu(item.priority) { 
                        ForEach(priority, id: \.self) { prio in
                            Button(prio.asString) {
                                item.priority = prio.asString
                            }
                        }
                    }
                    .foregroundStyle(.green)
                    
                } else if item.priority == "Mittel" {
                    Menu(item.priority) {
                        ForEach(priority, id: \.self) { prio in
                            Button(prio.asString) {
                                item.priority = prio.asString
                            }
                        }
                    }
                    .foregroundStyle(.blue)
                    
                } else if item.priority == "Hoch" {
                    Menu(item.priority) {
                        ForEach(priority, id: \.self) { prio in
                            Button(prio.asString) {
                                item.priority = prio.asString
                            }
                        }
                    }
                    .foregroundStyle(.orange)
                    
                } else if item.priority == "Dringend" {
                    Menu(item.priority) {
                        ForEach(priority, id: \.self) { prio in
                            Button(prio.asString) {
                                item.priority = prio.asString
                            }
                        }
                    }
                    .foregroundStyle(.red)
                }
                
                Button { editSheet.toggle() } label: {
                    Image(systemName: "info.circle")
                }
                .buttonStyle(BorderlessButtonStyle())
                .foregroundStyle(.primary)
                
            }
        }
        
        .sheet(isPresented: $editSheet) {
            EditTodoView(person: person/*, priority: $item.priority*/, item: item, todoName: $item.todoName)
        }
    }
}

#Preview {
    Todolist(navTitle: "Todoliste", listInfo: ListInfo(listName: "", backgroundColor: .blue, accentColor: .white))
}
