//
//  ModelSchemaV3.swift
//  TestListApp
//
//  Created by Michael Ilic on 02.05.24.
//

import Foundation
import SwiftUI
import SwiftData

enum ModelSchemaV3: VersionedSchema {
    
    static var versionIdentifier = Schema.Version(3, 0, 0)
    
    static var models: [any PersistentModel.Type] {
        [EinkaufModel.self, Person.self, TodolistItem.self]
    }
    
    @Model
    class EinkaufModel {
        var name: String
        var anzahl: Int
        var isDone: Bool = false
        
        init(name: String, anzahl: Int) {
            self.name = name
            self.anzahl = anzahl
        }
    }
    
    @Model
    class Person: Identifiable, ObservableObject {
        let id = UUID()
        var name: String
        var item: [TodolistItem]
        
        init(name: String, item: [TodolistItem]) {
            self.name = name
            self.item = item
        }
    }

    @Model
    class TodolistItem: Identifiable, ObservableObject {
        let id = UUID()
        var todoName: String
        var priority: String
        
        init(todoName: String, priority: String) {
            self.todoName = todoName
            self.priority = priority
        }
    }
}
