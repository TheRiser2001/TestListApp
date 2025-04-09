//
//  TaskCategory.swift
//  TaskPlanner
//
//  Created by Michael Ilic on 09.07.24.
//

import Foundation
import SwiftUI

// MARK: Category Enum with Color
enum Category: String, CaseIterable {
    case general = "General"
    case bug = "Bug"
    case idea = "Idea"
    case modifiers = "Modifiers"
    case challenge = "Challenge"
    case coding = "Coding"
    
    var color: Color {
        switch self {
        case .general:
            return Color("sky")
        case .bug:
            return Color("orange")
        case .idea:
            return Color("teal")
        case .modifiers:
            return Color("purple")
        case .challenge:
            return Color("magenta")
        case .coding:
            return Color("indigo")
        }
    }
}
