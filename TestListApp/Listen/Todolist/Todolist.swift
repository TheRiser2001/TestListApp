//
//  Todolist.swift
//  TestListApp
//
//  Created by Michael Ilic on 25.03.24.
//

import SwiftUI
import SwiftData

class NewPerson: Identifiable, ObservableObject {
    let id = UUID()
    @Published var name: String
    @Published var items: [NewTodoItem]
    
    init(name: String, items: [NewTodoItem]) {
        self.name = name
        self.items = items
    }
}

class NewTodoItem: Identifiable, ObservableObject {
    
    let id = UUID()
    @Published var todoName: String
    @Published var priority: Priority
    @Published var notiz: String
    @Published var date: Date
    @Published var hour: Date
    @Published var dateToggle: Bool
    @Published var hourToggle: Bool
    
    init(todoName: String, priority: Priority, notiz: String, date: Date = .now, hour: Date = .now, dateToggle: Bool = false, hourToggle: Bool = false) {
        self.todoName = todoName
        self.priority = priority
        self.notiz = notiz
        self.date = date
        self.hour = hour
        self.dateToggle = dateToggle
        self.hourToggle = hourToggle
    }
}

struct Todolist: View {
    @Environment(\.modelContext) var context
    @State private var personenTest: [NewPerson] = [
        NewPerson(name: "Michi", items: [NewTodoItem(todoName: "Putzen", priority: .niedrig, notiz: "")]),
        NewPerson(name: "Tina", items: [NewTodoItem(todoName: "Essen machen", priority: .dringend, notiz: "")])
    ]
//    @Query var personen: [Person]
    
    @State private var personIdWithoutItems: UUID?
    @State private var addSheet: Bool = false
    @State private var showAlert: Bool = false
    
    let listInfo: ListInfo
    
    var body: some View {
        
//        NavigationStack {
            ZStack {
                List {
                    ForEach(personenTest.indices, id: \.self) { index in
                        SectionRowView(personIdWithoutItems: $personIdWithoutItems, person: personenTest[index])
                    }
                }
                .listStyle(.sidebar)
                .onChange(of: personIdWithoutItems) { _, newVal in
                    if newVal != nil {
                        showAlert = true
                    }
                }
                
                if personenTest.isEmpty {
                    EmptyStateView(sfSymbol: "star.fill", message: "Du hast alle deine Aufgaben erledigt.")
                }
            }
            .alert("Person löschen?", isPresented: $showAlert) {
                Button("Behalten", role: .cancel) {
                    personIdWithoutItems = nil
                }
                Button("Löschen", role: .destructive) {
                    if let index = personenTest.firstIndex(where: { $0.id == personIdWithoutItems }) {
                        personenTest.remove(at: index)
//                        context.delete(personenTest[index])
                    }
                    personIdWithoutItems = nil
                }
            } message: {
                Text("Alle Aufgaben wurden erledigt. Möchtest du die Person aus der Lsite entfernen?")
            }
            .navigationTitle("Todos")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        addSheet.toggle()
                    } label: {
                        Image(systemName: "plus.circle")
                    }
                }
            }
//        }
        
        .sheet(isPresented: $addSheet) {
            AddTodoSectionView(personen: $personenTest)
//                .presentationDetents([.fraction(0.6)])
        }
        
        .toolbarBackground(listInfo.backgroundColor.opacity(0.6), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}

struct SectionRowView: View {
    
    @Environment(\.modelContext) var context
    
    @State private var isExpanded: Bool = true
    
    @Binding var personIdWithoutItems: UUID?
    
    @ObservedObject var person: NewPerson
    
    var body: some View {
        
        Section(isExpanded: $isExpanded) {
            ForEach(person.items, id: \.id) { item in
                TodoRowView(item: item, person: person)
            }
            .onDelete { offSet in
                person.items.remove(atOffsets: offSet)
                if person.items.isEmpty {
                    personIdWithoutItems = person.id
                }
            }
            
            Button {
                let newItem = NewTodoItem(todoName: "", priority: .niedrig, notiz: "", date: .now)
                withAnimation {
                    person.items.append(newItem)
                }
            } label: {
                HStack {
                    Image(systemName: "plus")
                    Text("Neues Todo hinzufügen")
                }
                .foregroundStyle(.blue)
            }
        } header: { Text(person.name) }
    }
}

struct TodoRowView: View {
    
    @State private var isDone: Bool = false
    
    @State private var editSheet: Bool = false
    
    @ObservedObject var item: NewTodoItem
    @ObservedObject var person: NewPerson
    
    var body: some View {
        VStack {
            HStack {
                Button{
                    guard item.todoName != "" else { return }
                    withAnimation {
                        isDone.toggle()
                    }
                } label: {
                    Image(systemName: isDone ? "checkmark.circle.fill" : "checkmark.circle")
                        .foregroundStyle(isDone ? .green : .red)
                }
                
                TextField("Todo eintragen", text: $item.todoName)
                    .strikethrough(isDone ? true : false)
                    .foregroundStyle(isDone ? Color.gray.opacity(0.7) : Color.primary)
                Spacer()
                
                Menu(item.priority.asString) {
                    ForEach(Priority.allCases, id: \.self) { prio in
                        Button(prio.asString) {
//                            item.priority.asString = prio.asString
                        }
                    }
                }
                .foregroundStyle(item.priority.color)
                

//                if item.priority == .niedrig {
//                    Menu(item.priority) { priority in
//                        ForEach(priority, id: \.self) { prio in
//                            Button(prio.asString) {
//                                item.priority = prio.asString
//                            }
//                        }
//                    }
//                    .foregroundStyle(.green)
//                    
//                } else if item.priority == .mittel {
//                    Menu(item.priority) { priority in
//                        ForEach(priority, id: \.self) { prio in
//                            Button(prio.asString) {
//                                item.priority = prio.asString
//                            }
//                        }
//                    }
//                    .foregroundStyle(.blue)
//                    
//                } else if item.priority == .hoch {
//                    Menu(item.priority) { priority in
//                        ForEach(priority, id: \.self) { prio in
//                            Button(prio.asString) {
//                                item.priority = prio.asString
//                            }
//                        }
//                    }
//                    .foregroundStyle(.orange)
//                    
//                } else if item.priority == .dringend {
//                    Menu(item.priority) { priority in
//                        ForEach(priority, id: \.self) { prio in
//                            Button(prio.asString) {
//                                item.priority = prio.asString
//                            }
//                        }
//                    }
//                    .foregroundStyle(.red)
//                }
                
                Button { editSheet.toggle() } label: {
                    Image(systemName: "info.circle")
                }
                .buttonStyle(BorderlessButtonStyle())
                .foregroundStyle(.primary)
                
            }
        }
        
        .sheet(isPresented: $editSheet) {
            EditTodoView(person: person/*, priority: $item.priority*/, item: item)
        }
    }
}

//#Preview {
//    NavigationStack {
//        Todolist(listInfo: ListInfo(listName: "", systemName: "cart", backgroundColor: .blue, accentColor: .white))
//    }
//}
