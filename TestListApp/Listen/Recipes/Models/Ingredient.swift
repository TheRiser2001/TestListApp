//
//  Ingredient.swift
//  TestListApp
//
//  Created by Michael Ilic on 03.04.25.
//

import Foundation
import SwiftData

@Model
class Ingredient: Identifiable {
    var id: UUID
    var name: String
    var amount: Int
    var unit: Unit
    
    init(id: UUID = UUID(), name: String, amount: Int, unit: Unit) {
        self.id = id
        self.name = name
        self.amount = amount
        self.unit = unit
    }
}
