//
//  EditTodoView.swift
//  TestListApp
//
//  Created by Michael Ilic on 16.04.24.
//
// MARK: Wenn ich $item.irgendwas verwende, werden die SectionHeader riesig.
// MARK: Binding von priority wird nicht in die EditView übernommen und man kann diese auch nicht ändern

import SwiftUI

struct EditTodoView: View {
    
    @Namespace private var ns
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var person: Person
    @ObservedObject var item: TodolistItem
    
    @State private var sectionTextField: String = ""
    @State private var notizenEditor: String = ""
    @State private var priority: Priority = .niedrig
    
    @State private var dateToggle: Bool = false
    @State private var hoursToggle: Bool = false
    @State private var date: Date = .now
    @State private var hour: Date = .now
    
    @Binding var todoName: String
    
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
                    TextField("", text: $sectionTextField, prompt: Text("Name der Person"))
                }
                
                Section("Todo") {
                    TextField("", text: $todoName, prompt: Text("Füge ein Todo hinzu"))
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
                    if dateToggle == true {
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
                        
                        if hoursToggle == true {
                            DatePicker("", selection: $hour, displayedComponents: .hourAndMinute)
                                .datePickerStyle(.wheel)
                        }
                    }
                }
                
                Section("Priority") {
                    Picker("", selection: $priority) {
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
                            priority.color
                            Text(priority.asString)
                                .font(.footnote)
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                        }
                        .matchedGeometryEffect(id: priority, in: ns, isSource: false)
                        .clipShape(RoundedRectangle(cornerRadius: 7))
                        .animation(.spring(duration: 0.28), value: priority)
                    }
                }
                
                Section("Notizen") {
                    TextEditor(text: $notizenEditor)
                        .frame(height: 200)
                }
                
                Button("Person löschen", role: .destructive) {
                    
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
    EditTodoView(person: Person(name: "Michi", item: [TodolistItem(todoName: "Test", priority: "Niedrig")])/*, priority: .constant(.hoch)*/, item: TodolistItem(todoName: "Test", priority: "Niedrig"), todoName: .constant("Irgendein todo"))
}
