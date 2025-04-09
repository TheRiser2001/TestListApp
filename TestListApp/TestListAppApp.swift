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
    @State private var backgroundColor: Color = .red
    
    init() {
        do {
            container = try ModelContainer(for: GroceryCategory.self, GroceryItem.self, Person.self, TodolistItem.self, Recipe.self/*, migrationPlan: DatabaseMigrationPlan.self*/)
        } catch {
            fatalError("Fehler beim erstellen")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            //MainTabView()
            MainListView(backgroundColor: $backgroundColor)
                .modelContainer(container)
        }
    }
}
