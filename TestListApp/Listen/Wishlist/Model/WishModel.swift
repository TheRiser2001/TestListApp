//
//  WunschModel.swift
//  TestListApp
//
//  Created by Michael Ilic on 21.06.24.
//

import Foundation
import SwiftUI
import SwiftData

// - Da SwiftData keine eigenen Typen handeln kann, musste es umgewandelt werden
// - Get wird immer aufgerufen wenn der Wert der priority Eigenschaft abgerufen wird und Set wenn ein neuer Wert der priority Eigenschaft zugewiesen wird
// - Bei der Getter Methode wird der priorityRaw-Wert von einem Int16 in eine Priority umgewandelt
// - Bei der Setter Methode umgekehrt. Ein Priority Enum-Wert wird in einen Int16 Wert umgewandelt und in priorityRaw gespeichert

@Model
class WishModel: Identifiable, Hashable, ObservableObject {
    var id: UUID = UUID()
    var name: String
    var priorityRaw: Int16
    var date: Date
    var cost: Double
    var saved: Double
    var notes: String
    var isDone: Bool
    
    var gaugePercent: Double { (saved/cost) }
    
    var priority: Priority {
        get { Priority(rawValue: Int(priorityRaw)) ?? .niedrig }
        set { priorityRaw = Int16(newValue.rawValue) }
    }
    
    init(name: String, priority: Priority, date: Date, cost: Double, saved: Double = 0, notes: String = "", isDone: Bool = false) {
        self.name = name
        self.priorityRaw = Int16(priority.rawValue)
        self.date = date
        self.cost = cost
        self.saved = saved
        self.notes = notes
        self.isDone = isDone
    }
}
