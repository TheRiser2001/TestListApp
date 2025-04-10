//
//  GroceryCategory.swift
//  TestListApp
//
//  Created by Michael Ilic on 10.04.25.
//

import Foundation
import SwiftData

@Model
class GroceryCategory: Identifiable, ObservableObject {
    var id = UUID()
    var name: String
    var items: [GroceryItem]
    var systemName: String?
    var createdAt: Date
    
    init(name: String, items: [GroceryItem], systemName: String? = nil) {
        self.name = name
        self.items = items
        self.systemName = systemName
        self.createdAt = Date()
    }
}

