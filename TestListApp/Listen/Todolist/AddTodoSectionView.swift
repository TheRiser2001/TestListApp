//
//  AddTodoSectionView.swift
//  TestListApp
//
//  Created by Michael Ilic on 16.04.24.
//

import SwiftUI
import SwiftData

struct AddTodoSectionView: View {
    
    @Namespace private var ns
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context

    @State private var sectionTextField: String = ""
    @State private var todoTextField: String = ""
    @State private var notizenEditor: String = ""
    @State private var prioPicker: Priority = .niedrig
    @State private var addAlert: Bool = false
    
    @State private var dateToggle: Bool = false
    @State private var hoursToggle: Bool = false
    @State private var date: Date = .now
    @State private var hour: Date = .now
    
    let personen: [Person]
    
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
                        TextField("", text: $sectionTextField, prompt: Text("Füge eine neue Person hinzu"))
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
                        TextEditor(text: $notizenEditor)
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
            }
            
            .alert("Du hast den Namen vergessen", isPresented: $addAlert) {
                
            } message: {
                Text("Du musst zuerst einen Namen eingeben bevor du speichern kannst")
            }
        }
    }
    
    func addItem() {
        let newTodo = TodolistItem(todoName: todoTextField, priority: prioPicker.asString)
        let newItem = Person(name: sectionTextField, item: [newTodo])
//        MARK: Das guard ist dafür, dass ein Name eingetragen sein muss. Für Testzwecke auskommentiert
//        guard sectionTextField != "" else {
//            addAlert.toggle()
//            return
//        }
        context.insert(newItem)
        dismiss()
    }
}

#Preview {
    @State var personen: [Person] = [
        Person(name: "Michi", item: [
            TodolistItem(todoName: "Reifenwechsel", priority: "Niedrig"),
            TodolistItem(todoName: "Büro gehen", priority: "Dringend!"),
            TodolistItem(todoName: "Irgendwas", priority: "Mittel")
        ].sorted { $0.priority < $1.priority }),
        Person(name: "Tina", item: [
            TodolistItem(todoName: "Haushalt", priority: "Dringend!")
        ])
    ]
    return AddTodoSectionView(personen: personen)
}
