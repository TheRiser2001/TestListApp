//
//  Instruction.swift
//  TestListApp
//
//  Created by Michael Ilic on 03.04.25.
//

import Foundation
import SwiftData

@Model
class Instruction: Identifiable {
    var id: UUID
    var step: String
    
    init(id: UUID = UUID(), step: String) {
        self.id = id
        self.step = step
    }
}
