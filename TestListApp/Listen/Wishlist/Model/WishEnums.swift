//
//  WishEnums.swift
//  TestListApp
//
//  Created by Michael Ilic on 10.04.25.
//

import Foundation
import SwiftUI

enum Priority: Int, CaseIterable {
    case niedrig = 3
    case mittel = 2
    case hoch = 1
    case dringend = 0
    
    var asString: String {
        "\(self)".capitalized
    }
    
    var color: Color {
        switch self {
        case .niedrig: return .green
        case .mittel: return .blue
        case .hoch: return .orange
        case .dringend: return .red
        }
    }
    
    var int16Value: Int16 {
        return Int16(self.rawValue)
    }
}

enum Period: CaseIterable {
    case day
    case week
    case month
    
    var asString: String {
        "\(self)".capitalized
    }
    
    var maxSliderVal: Int {
        switch self {
        case .day: 31
        case .week: 52
        case .month: 12
        }
    }
}
