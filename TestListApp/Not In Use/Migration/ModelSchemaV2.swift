//
//  ModelSchemaV1.swift
//  TestListApp
//
//  Created by Michael Ilic on 03.02.24.
//

import Foundation
import SwiftUI
import SwiftData

enum ModelSchemaV2: VersionedSchema {
    
    static var versionIdentifier = Schema.Version(2, 0, 0)
    
    static var models: [any PersistentModel.Type] {
        [EinkaufModel.self]
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
    
}
