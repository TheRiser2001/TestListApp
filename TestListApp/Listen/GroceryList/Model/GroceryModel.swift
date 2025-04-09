//
//  GroceryModel.swift
//  TestListApp
//
//  Created by Michael Ilic on 07.04.25.
//

import SwiftUI
import SwiftData

enum Supermarkt: CaseIterable, Codable {
    case billa
    case spar
    case hofer
    case lidl
    case bipa
    
    var color: Color {
        switch self {
        case .billa: return .yellow
        case .spar: return .green
        case .hofer: return .red
        case .lidl: return .orange
        case .bipa: return .blue
        }
    }
}

enum GroceryUnit: CaseIterable, Codable {
    case portion
    case gramm
    case milliliter
    case liter
    
    var asString: String {
        return "\(self)".capitalized
    }
    
    var short: String {
        switch self {
        case .portion: return "x"
        case .gramm: return "g"
        case .milliliter: return "ml"
        case .liter: return "l"
        }
    }
}

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
