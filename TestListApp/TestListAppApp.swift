//
//  TestListAppApp.swift
//  TestListApp
//
//  Created by Michael Ilic on 02.02.24.
//

import SwiftUI
import SwiftData

@main
struct TestListAppApp: App {
    
    let container: ModelContainer
    
    init() {
        do {
            container = try ModelContainer(for: GroceryCategory.self, GroceryItem.self, Person.self, TodolistItem.self, WishModel.self, Recipe.self/*, migrationPlan: DatabaseMigrationPlan.self*/)
        } catch {
            fatalError("Fehler beim erstellen")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            MainListView()
                .modelContainer(container)
        }
    }
}
