//
//  WunschModel.swift
//  TestListApp
//
//  Created by Michael Ilic on 21.06.24.
//

import Foundation
import SwiftUI

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
