//
//  PresentModel.swift
//  TestListApp
//
//  Created by Michael Ilic on 10.04.25.
//

import Foundation

class PresentPerson: ObservableObject, Identifiable {
    let id = UUID()
    @Published var name: String
    @Published var items: [PresentItem]
    
    init(name: String, items: [PresentItem]) {
        self.name = name
        self.items = items
    }
}
