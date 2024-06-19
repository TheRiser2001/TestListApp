//
//  ModelSchemaV1.swift
//  TestListApp
//
//  Created by Michael Ilic on 03.02.24.

import Foundation
import SwiftUI
import SwiftData

enum ModelSchemaV1: VersionedSchema {
    
    static var versionIdentifier = Schema.Version(1, 0, 0)
    
    static var models: [any PersistentModel.Type] {
        [EinkaufModel.self]
    }
    
    @Model
    class EinkaufModel {
        var name: String
        var anzahl: Int
        
        init(name: String, anzahl: Int) {
            self.name = name
            self.anzahl = anzahl
        }
    }
}

extension EinkaufModel {
    
    @MainActor
    static var preview: ModelContainer {
        let container = try! ModelContainer(for: EinkaufModel.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        
        container.mainContext.insert(EinkaufModel(name: "Test1", anzahl: 5))
        
        return container
    }
}
