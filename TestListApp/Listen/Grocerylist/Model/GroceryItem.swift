//
//  GroceryItem.swift
//  TestListApp
//
//  Created by Michael Ilic on 10.04.25.
//

import Foundation
import SwiftData

@Model
class GroceryItem: Identifiable, ObservableObject {
    var id = UUID()
    var name: String
    var supermarkt: Supermarkt
    var unit: GroceryUnit
    var anzahl: Int
    var isDone: Bool
    
    init(name: String, supermarkt: Supermarkt, unit: GroceryUnit = .portion, anzahl: Int, isDone: Bool = false) {
        self.name = name
        self.supermarkt = supermarkt
        self.unit = unit
        self.anzahl = anzahl
        self.isDone = isDone
    }
}

