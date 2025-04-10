//
//  TodoItem.swift
//  TestListApp
//
//  Created by Michael Ilic on 10.04.25.
//

import Foundation

class TodoItem: Identifiable, ObservableObject {
    let id = UUID()
    @Published var todoName: String
    @Published var priority: Priority
    @Published var notes: String
    @Published var date: Date
    @Published var hour: Date
    @Published var dateToggle: Bool
    @Published var hourToggle: Bool
    
    init(todoName: String, priority: Priority, note: String, date: Date = .now, hour: Date = .now, dateToggle: Bool = false, hourToggle: Bool = false) {
        self.todoName = todoName
        self.priority = priority
        self.notes = note
        self.date = date
        self.hour = hour
        self.dateToggle = dateToggle
        self.hourToggle = hourToggle
    }
}
