//
//  EinkaufModel.swift
//  TestListApp
//
//  Created by Michael Ilic on 02.02.24.
//

import Foundation
import SwiftUI
import SwiftData

@Model
class Einkauf {
    var name: String
    var anzahl: Int
    
    init(name: String, anzahl: Int) {
        self.name = name
        self.anzahl = anzahl
    }
}

extension Einkauf {
    
    @MainActor
    static var preview: ModelContainer {
        let container = try! ModelContainer(for: Einkauf.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        
        container.mainContext.insert(Einkauf(name: "Test1", anzahl: 5))
        
        return container
    }
}

@Model
class ObstArray {
    let name: String
    
    init(name: String) {
        self.name = name
    }
}

@Model
class FleischArray {
    let name: String
    
    init(name: String) {
        self.name = name
    }
}

struct MockData {
    static let sampleEinkauf = Einkauf(name: "Apfel", anzahl: 3)
    
    static let einkäufe = [sampleEinkauf, sampleEinkauf, sampleEinkauf]
}


class Kategorie: Identifiable {
    let id = UUID()
    //let item: Einkauf             //Möglich eventuell für Array in Array
    let title: String
    let titleColor: Color
    
    init(title: String, titleColor: Color) {
        self.title = title
        self.titleColor = titleColor
    }
}

