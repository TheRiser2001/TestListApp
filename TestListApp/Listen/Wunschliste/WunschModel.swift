//
//  WunschModel.swift
//  TestListApp
//
//  Created by Michael Ilic on 21.06.24.
//

import Foundation
import SwiftUI


enum Priority: Int, CaseIterable {
    case niedrig
    case mittel
    case hoch
    case dringend
    
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
}

enum Period: CaseIterable {
    case tag
    case woche
    case monat
    
    var asString: String {
        "\(self)".capitalized
    }
    
    var maxSliderVal: Int {
        switch self {
        case .tag: 31
        case .woche: 52
        case .monat: 12
        }
    }
}

struct WunschModel: Hashable {
    var id: UUID
    var name: String
    var priority: Priority
    var date: Date
    var kosten: Double
    var gespart: Double
    var notizen: String
    
    var gaugeProzent: Double { (gespart/kosten) }
//    var gaugeRing: Double
    
    init(name: String, priority: Priority, date: Date, kosten: Double, gespart: Double = 0, notizen: String = "") {
        self.id = .init()
        self.name = name
        self.priority = priority
        self.date = date
        self.kosten = kosten
        self.gespart = gespart
        self.notizen = notizen
    }
}

struct PriorityPicker: View {
    
    @Namespace private var ns
    @Binding var prioPicker: Priority
    
    var body: some View {
        
        Picker("", selection: $prioPicker) {
            ForEach(Priority.allCases, id: \.self) { prio in
                Text(prio.asString)
            }
        }
        .pickerStyle(.segmented)
        .background {
            
            HStack(spacing: 0) {
                ForEach(Priority.allCases, id: \.self) { prio in
                    Color.clear
                        .matchedGeometryEffect(id: prio, in: ns, isSource: true)
                }
            }
        }
        .overlay {
            ZStack {
                prioPicker.color
                Text(prioPicker.asString)
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
            }
            .matchedGeometryEffect(id: prioPicker, in: ns, isSource: false)
            .clipShape(RoundedRectangle(cornerRadius: 7))
            .animation(.spring(duration: 0.28), value: prioPicker)
        }
    }
}
