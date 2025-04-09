//
//  Enums.swift
//  TestListApp
//
//  Created by Michael Ilic on 03.04.25.
//

import Foundation
import SwiftUI

enum Mealtime: CaseIterable, Codable {
    case breakfast
    case lunch
    case dinner
    case dessert
    case snacks
    
    var asString: String {
        return "\(self)".capitalized
    }
}

enum Difficulty: CaseIterable, Codable {
    case easy
    case intermediate
    case hard
    
    var asString: String {
        switch self {
        case .easy: return "Leicht"
        case .intermediate: return "Mittel"
        case .hard: return "Schwer"
        }
    }
    
    var color: Color {
        switch self {
        case .easy: return .green
        case .intermediate: return .orange
        case .hard: return .red
        }
    }
}

enum Unit: CaseIterable, Codable {
    case anzahl
    case gramm
    case milliliter
    case kilogramm
    case liter
    
    var asString: String {
        return "\(self)".capitalized
    }
    
    var short: String {
        switch self {
        case .anzahl: return "x"
        case .gramm: return "g"
        case .milliliter: return "ml"
        case .kilogramm: return "kg"
        case .liter: return "l"
        }
    }
}
