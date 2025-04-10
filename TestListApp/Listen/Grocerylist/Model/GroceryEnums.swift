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
