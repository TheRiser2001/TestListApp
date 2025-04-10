//
//  EditTodoView.swift
//  TestListApp
//
//  Created by Michael Ilic on 16.04.24.
//
// MARK: Wenn ich $item.irgendwas verwende, werden die SectionHeader riesig.
// MARK: Binding von priority wird nicht in die EditView übernommen und man kann diese auch nicht ändern

import SwiftUI

struct EditTodo: View {
    
    @Namespace private var ns
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var person: TodoPerson
    @ObservedObject var item: TodoItem
    
    private let hourFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Name") {
                    TextField("", text: $person.name, prompt: Text("Name der Person"))
                }
                
//                Section("Todo") {
//                    TextField("", text: $item.todoName, prompt: Text("Füge ein Todo hinzu"))
//                    Toggle(isOn: $item.dateToggle.animation()) {
//                        HStack {
//                            Image(systemName: "calendar")
//                            VStack {
//                                Text("Datum")
//                                    .bold()
//                                if item.dateToggle {
//                                    Text(dateFormatter.string(from: item.date))
//                                        .font(.footnote)
//                                }
//                            }
//                        }
//                    }
//                    
//                }
                
                Section("Todo") {
                        TextField("", text: $item.todoName, prompt: Text("Füge ein Todo hinzu"))
                        Toggle(isOn: $item.dateToggle.animation()) {
                            HStack {
                                Image(systemName: "calendar")
                                VStack(alignment: .leading) {
                                    Text("Datum")
                                        .bold()
                                    if item.dateToggle {
                                        Text(dateFormatter.string(from: item.date))
                                            .font(.footnote)
                                    }
                                }
                            }
                        }
                        if item.dateToggle {
                            DatePicker("", selection: $item.date, displayedComponents: .date)
                                .datePickerStyle(.graphical)
                            
                            HStack {
                                Image(systemName: "clock")
                                Toggle(isOn: $item.hourToggle.animation()) {
                                    VStack(alignment: .leading) {
                                        Text("Uhrzeit")
                                            .bold()
                                        if item.hourToggle {
                                            Text(hourFormatter.string(from: item.hour))
                                                .font(.footnote)
                                        }
                                    }
                                }
                            }
                            
                            if item.hourToggle {
                                DatePicker("", selection: $item.hour, displayedComponents: .hourAndMinute)
                                    .datePickerStyle(.wheel)
                            }
                        }
                }
                
                Section("Priority") {
                    Picker("", selection: $item.priority) {
                        ForEach(Priority.allCases, id: \.self) { priority in
                            Text(priority.asString)
                        }
                    }
                    .pickerStyle(.segmented)
                    .background {
                        
                        HStack(spacing: 0) {
                            ForEach(Priority.allCases, id: \.self) { priority in
                                Color.clear
                                    .matchedGeometryEffect(id: priority, in: ns, isSource: true)
                            }
                        }
                    }
                    .overlay {
                        ZStack {
                            item.priority.color
                            Text(item.priority.asString)
                                .font(.footnote)
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                        }
                        .matchedGeometryEffect(id: item.priority, in: ns, isSource: false)
                        .clipShape(RoundedRectangle(cornerRadius: 7))
                        .animation(.spring(duration: 0.28), value: item.priority)
                    }
                }
                
                Section("Notizen") {
                    TextEditor(text: $item.notes)
                        .frame(height: 200)
                }
                
                Button("Todo erledigt") {
                    
                }
                
                Section {
                    Button("Todo löschen", role: .destructive) {
                        
                    }
                    Button("Person löschen", role: .destructive) {
                        
                    }
                }
            }
            .navigationTitle("Informationen")
            .navigationBarTitleDisplayMode(.inline)
            
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Abbrechen") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        
                    }
                }
            }
        }
    }
}

#Preview {
//    EditTodoView(person: Person(name: "Michi", item: [TodolistItem(todoName: "Test", priority: "Niedrig")])/*, priority: .constant(.hoch)*/, item: TodolistItem(todoName: "Test", priority: "Niedrig"), todoName: .constant("Irgendein todo"))
    EditTodo(person: TodoPerson(name: "Michi", items: [TodoItem(todoName: "Essen", priority: .mittel, note: "", date: .now)]), item: TodoItem(todoName: "Essen", priority: .mittel, note: "", date: .now))
}
