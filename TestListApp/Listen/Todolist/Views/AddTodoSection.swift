//
//  AddTodoSectionView.swift
//  TestListApp
//
//  Created by Michael Ilic on 16.04.24.
//

import SwiftUI
import SwiftData

struct AddTodoSection: View {
    
    @Namespace private var ns
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context

    @State private var personNameTextField: String = ""
    @State private var todoTextField: String = ""
    @State private var noteEditor: String = ""
    @State private var prioPicker: Priority = .niedrig
    
    @State private var addAlert: Bool = false
    @State private var dateToggle: Bool = false
    @State private var hoursToggle: Bool = false
    
    @State private var date: Date = .now
    @State private var hour: Date = .now
    
    @Binding var people: [TodoPerson]
    
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
            VStack {
                Form {
                    Section("Name") {
                        TextField("", text: $personNameTextField, prompt: Text("Füge eine neue Person hinzu"))
                    }
                    
                    Section("Todo hinzufügen") {
                        TextField("", text: $todoTextField, prompt: Text("Füge ein Todo hinzu"))
                        Toggle(isOn: $dateToggle.animation()) {
                            HStack {
                                Image(systemName: "calendar")
                                VStack(alignment: .leading) {
                                    Text("Datum")
                                        .bold()
                                    if dateToggle {
                                        Text(dateFormatter.string(from: date))
                                            .font(.footnote)
                                    }
                                }
                            }
                        }
                        if dateToggle {
                            DatePicker("", selection: $date, displayedComponents: .date)
                                .datePickerStyle(.graphical)
                            
                            HStack {
                                Image(systemName: "clock")
                                Toggle(isOn: $hoursToggle.animation()) {
                                    VStack(alignment: .leading) {
                                        Text("Uhrzeit")
                                            .bold()
                                        if hoursToggle {
                                            Text(hourFormatter.string(from: hour))
                                                .font(.footnote)
                                        }
                                    }
                                }
                            }
                            
                            if hoursToggle {
                                DatePicker("", selection: $hour, displayedComponents: .hourAndMinute)
                                    .datePickerStyle(.wheel)
                            }
                        }
                    }
                    
                    Section("Priorität") {
                        Picker("", selection: $prioPicker) {
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
                                prioPicker.color
                                Text(prioPicker.asString)
                                    .font(.footnote)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.white)
                            }
                            .matchedGeometryEffect(id: prioPicker, in: ns, isSource: false)
                            .clipShape(RoundedRectangle(cornerRadius: 7))
                            .animation(.spring(duration: 0.28), value: prioPicker)
                        }
                    }
                    
                    Section("Notizen") {
                        TextEditor(text: $noteEditor)
                            .frame(height: 200)
                    }
                }
            }
            .navigationTitle("Neue Person")
            .navigationBarTitleDisplayMode(.inline)
            
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        addItem()
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button("Abbruch") {
                        dismiss()
                    }
                }
            }
            
            .alert("Du hast den Namen vergessen", isPresented: $addAlert) {
                
            } message: {
                Text("Du musst zuerst einen Namen eingeben bevor du speichern kannst")
            }
        }
    }
    
    func addItem() {
        let newTodo = TodoItem(todoName: todoTextField, priority: prioPicker, note: "", date: .now)
        let newPerson = TodoPerson(name: personNameTextField, items: [newTodo])
//        MARK: Das guard ist dafür, dass ein Name eingetragen sein muss. Für Testzwecke auskommentiert
//        guard sectionTextField != "" else {
//            addAlert.toggle()
//            return
//        }
        
//        context.insert(newPerson)
        people.append(newPerson)
        dismiss()
    }
}

#Preview {
    @State var people: [TodoPerson] = [
        TodoPerson(name: "Michi", items: [TodoItem(todoName: "Putzen", priority: .niedrig, note: "", date: .now)]),
        TodoPerson(name: "Tina", items: [TodoItem(todoName: "Essen machen", priority: .dringend, note: "", date: .now)])
    ]
    return AddTodoSection(people: $people)
}
