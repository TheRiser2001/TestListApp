//
//  Enums.swift
//  TestListApp
//
//  Created by Michael Ilic on 10.04.25.
//

import Foundation
import SwiftUI

enum Status: CaseIterable, Comparable {
    case besorgt
    case unterwegs
    case ueberlegung
    case unmöglich
    
    var asString: String {
        switch self {
        case .ueberlegung: return "Überlegung"
        default: return "\(self)".capitalized
        }
    }
    
    var color: Color {
        switch self {
        case .besorgt: return .green
        case .unterwegs: return .blue
        case .ueberlegung: return .orange
        case .unmöglich: return .red
        }
    }
}
