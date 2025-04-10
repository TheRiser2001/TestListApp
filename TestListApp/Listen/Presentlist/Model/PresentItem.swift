//
//  PresentItem.swift
//  TestListApp
//
//  Created by Michael Ilic on 10.04.25.
//

import Foundation

class PresentItem: ObservableObject, Identifiable {
    let id = UUID()
    @Published var name: String
    @Published var status: Status
    @Published var price: Int
    @Published var showDate: Bool
    @Published var date: Date
    
    init(name: String, status: Status, price: Int, showDate: Bool, date: Date) {
        self.name = name
        self.status = status
        self.price = price
        self.showDate = showDate
        self.date = date
    }
}
