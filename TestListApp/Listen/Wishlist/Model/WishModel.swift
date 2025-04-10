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

struct WishModel: Hashable {
    var id: UUID
    var name: String
    var priority: Priority
    var date: Date
    var cost: Double
    var saved: Double
    var notes: String
    var isDone: Bool
    
    var gaugePercent: Double { (saved/cost) }
//    var gaugeRing: Double
    
    init(name: String, priority: Priority, date: Date, cost: Double, saved: Double = 0, notes: String = "", isDone: Bool = false) {
        self.id = .init()
        self.name = name
        self.priority = priority
        self.date = date
        self.cost = cost
        self.saved = saved
        self.notes = notes
        self.isDone = isDone
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
