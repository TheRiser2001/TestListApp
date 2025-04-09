//
//  Class, enums, extensions.swift
//  TestListApp
//
//  Created by Michael Ilic on 24.04.24.
//

import Foundation
import SwiftUI
import PhotosUI

class Rezeptur: Identifiable {
    let id = UUID()
    let name: String
    var anleitung: String
    @Published var selectedImage: Image?
    @Published var tageszeit: Tageszeit
    @Published var ernaehrung: Ernährung
    let kcal: Int
    let kohlenhydrate: Int
    let proteine: Int
    let fette: Int
    
    init(name: String, anleitung: String = "", selectedImage: Image? = nil, tageszeit: Tageszeit, ernaehrung: Ernährung, kcal: Int, kohlenhydrate: Int, proteine: Int, fette: Int) {
        self.name = name
        self.anleitung = anleitung
        self.tageszeit = tageszeit
        self.ernaehrung = ernaehrung
        self.kcal = kcal
        self.kohlenhydrate = kohlenhydrate
        self.proteine = proteine
        self.fette = fette
    }
}

enum Tageszeit: CaseIterable {
    case fruehstueck
    case mittagessen
    case abendessen
    case snack
    
    var asString: String {
        switch self {
        case .fruehstueck: return "Frühstück"
        default: return "\(self)".capitalized
        }
    }
}

enum Ernährung: CaseIterable {
    case vegan
    case vegetarisch
    case lowcarb
    case paleo
    case ketogen
    case massephase
    case definitionsphase
    case protein
    case mediterran
    case makronährstoff
    
    var asString: String {
        switch self {
        case .lowcarb: return "Low-Carb"
        default: return "\(self)".capitalized
        }
    }
}
