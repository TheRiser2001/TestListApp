//
//  Color+Extensions.swift
//  TestListApp
//
//  Created by Michael Ilic on 02.03.24.
//

import Foundation
import SwiftUI


enum Theme: String, CaseIterable {
    case indigo, red, blue, magenta, bubblegum, buttercup, navy, orange, oxblood, periwinkle, poppy, purple, silber, sky, tan, teal, yellow, cyan, green, mint, pink, brown, black, white, gray
    
    var mainColor: Color {
        Color(rawValue)
    }
    
    static func accentColor(for backgroundColor: Color) -> Color {
        switch backgroundColor {
        case .hellgrün, .tuerkis, .brown, .indigo, .red, .blue, .bubblegum, .buttercup, .silber, .orange, .periwinkle, .poppy, .purple, .gray, .sky, .tan, .teal, .yellow, .cyan, .green, .pink, .white:
            return .black
        case .magenta, .navy, .oxblood, .black:
            return .white
        default:
            return .black
        }
    }
    
    static func colorName(for backgroundColor: Color) -> String {
        switch backgroundColor {
        case .bubblegum:
            return "Bubblegum"
        default:
            return "Keine Farbe ausgewählt"
        }
    }
}

extension Color {
    var name: String {
        switch self {
        case .red: return "Rot"
        case .oxblood: return "Weinrot"
        case .poppy: return "Hellrosa"
        case .pink: return "Pink"
        case .magenta: return "Magenta"
        case .bubblegum: return "Rosa"
        case .purple: return "Violett"
        case .navy: return "Dunkelblau"
        case .blue: return "Blau"
        case .indigo: return "Indigo"
        case .sky: return "Himmelblau"
        case .cyan: return "Aquamarin"
        case .tuerkis: return "Türkis"
        case .hellgrün: return "Hellgrün"
        case .green: return "Grün"
        case .yellow: return "Gelb"
        case .buttercup: return "Hellgelb"
        case .orange: return "Orange"
        case .tan: return "Beige"
        case .brown: return "Braun"
        case .gray: return "Grau"
        case .silber: return "Silber"
        case .white: return "Weiß"
        case .black: return "Schwarz"
        default: return "Keine Farbe ausgewählt"
        }
    }
}

struct ColorPaletteView2: View {
    let colors: [Color] = [ .red, .oxblood, .poppy, .pink, .magenta, .bubblegum, .purple, .navy, .blue, .indigo, .sky, .cyan, .tuerkis, .hellgrün, .green, .yellow, .buttercup, .orange, .tan, .brown, .gray, .silber, .white, .black]
    /*
     let colors: [Color] = [.indigo, .blue, .sky, .mint, .cyan, .red, .magenta, .bubblegum, .buttercup, .lavender, .navy, .orange, .oxblood, .poppy, .purple, .seafoam, .tan, .yellow, .green, .pink, .brown, .gray, .white, .black]*/
    let colorsPerRow = 6
    @Binding var selectedColor: Color?
    
    var body: some View {
        VStack {
            Text("Farbe: \(selectedColor?.name ?? "None")")
                .padding()
            
            VStack {
                ForEach(0..<colors.count/colorsPerRow + 1, id: \.self) { rowIndex in
                    HStack {
                        ForEach(0..<min(colorsPerRow, colors.count - rowIndex*colorsPerRow), id: \.self) { colIndex in
                            let index = rowIndex * colorsPerRow + colIndex
                            Circle()
                                .fill(colors[index])
                                .overlay(
                                    Circle()
                                        .stroke(selectedColor == colors[index] ? Color.black : Color.clear, lineWidth: 3)
                                )
                                .frame(width: 30, height: 30)
                                .onTapGesture {
                                    self.selectedColor = colors[index]
                                }
                        }
                    }
                }
            }
        }
    }
}
