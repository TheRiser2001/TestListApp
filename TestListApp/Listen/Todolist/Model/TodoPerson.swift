//
//  NewPerson.swift
//  TestListApp
//
//  Created by Michael Ilic on 10.04.25.
//

import Foundation

class TodoPerson: Identifiable, ObservableObject {
    let id = UUID()
    @Published var name: String
    @Published var items: [TodoItem]
    
    init(name: String, items: [TodoItem]) {
        self.name = name
        self.items = items
    }
}
