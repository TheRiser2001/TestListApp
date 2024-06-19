//
//  DatabaseMigrationPlan.swift
//  TestListApp
//
//  Created by Michael Ilic on 03.02.24.
//

import Foundation
import SwiftData

enum DatabaseMigrationPlan: SchemaMigrationPlan {
    
    static var schemas: [any VersionedSchema.Type] {
        [ModelSchemaV2.self, ModelSchemaV3.self]
    }
    
    static let migrateV2toV3 = MigrationStage.custom(fromVersion: ModelSchemaV2.self, toVersion: ModelSchemaV3.self, willMigrate: { context in
        let testEinkauf = try context.fetch(FetchDescriptor<ModelSchemaV3.EinkaufModel>())
        let testPerson = try context.fetch(FetchDescriptor<ModelSchemaV3.Person>())
        let testTodo = try context.fetch(FetchDescriptor<ModelSchemaV3.TodolistItem>())
        
        var usedEinkauf = Set<String>()
        
        for einkäufe in testEinkauf {
            if usedEinkauf.contains(einkäufe.name) {
                context.delete(einkäufe)
            }
            
            usedEinkauf.insert(einkäufe.name)
        }
        
        try context.save()
        
    }, didMigrate: nil
)

    static var stages: [MigrationStage] {
        [migrateV2toV3]
    }
    
}
