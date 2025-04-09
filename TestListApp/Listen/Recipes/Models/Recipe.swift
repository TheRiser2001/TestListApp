//
//  Recipe.swift
//  TestListApp
//
//  Created by Michael Ilic on 03.04.25.
//

import Foundation

import Foundation
import SwiftUI
import SwiftData
    
//@Observable
@Model
class Recipe: Identifiable, ObservableObject {
    var id = UUID()
    var name: String
    var mealtime: Mealtime
    var ingredient: [Ingredient]
    var instructions: [Instruction]
    var calories: Int
    var duration: Int
    var difficulty: Difficulty
    var image: String
    var isFavorite: Bool
    
    init(name: String, mealtime: Mealtime, ingredient: [Ingredient], instructions: [Instruction], calories: Int, duration: Int, difficulty: Difficulty, image: String, isFavorite: Bool) {
        self.name = name
        self.mealtime = mealtime
        self.ingredient = ingredient
        self.instructions = instructions
        self.calories = calories
        self.duration = duration
        self.difficulty = difficulty
        self.image = image
        self.isFavorite = isFavorite
    }
}
