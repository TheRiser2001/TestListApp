//
//  AddRecipeView.swift
//  TestListApp
//
//  Created by Michael Ilic on 03.04.25.
//

import SwiftData
import SwiftUI
import PhotosUI

struct AddRecipeView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    @State private var instructionExpanding: Bool = true
    @State private var ingredientsExpanding: Bool = true
    
    @State private var newName: String = "Avocadosandwich"
    @State private var newMealtime: Mealtime = .breakfast
    @State private var newCalories: Int = 100
    @State private var newDuration: Int = 5
    @State private var newDifficulty: Difficulty = .easy
    @State private var newInstructions: [Instruction] = [
        Instruction(step: "Test")
    ]
    @State private var newIngredients: [Ingredient] = [Ingredient(name: "Test Ingredient", amount: 5, unit: .milliliter)]
    
    //MARK: - BIS HIER LÖSCHEN
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: Image = Image("NoImage")
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .topLeading) {
                
                Color.blue.opacity(0.2)
                    .ignoresSafeArea()
                
                VStack(alignment: .leading) {
                    HStack {
                        PhotosPicker(selection: $selectedItem) {
                            selectedImage
                                .resizable()
                                .frame(width: 150, height: 150)
                                .scaledToFill()
                                .background {
                                    Rectangle()
                                        .stroke()
                                        .frame(width: 151, height: 151)
                                }
                                .padding(.top)
                        }
                        .onChange(of: selectedItem) {
                            Task {
                                if let loaded = try? await selectedItem?.loadTransferable(type: Image.self) {
                                    selectedImage = loaded
                                } else {
                                    print("Failed")
                                }
                            }
                        }
                        
                        VStack (alignment: .leading) {
                            Text("Name")
                                .font(.footnote)
                                .foregroundStyle(.gray)
                                .padding(.leading, 15)
                                .padding(.top, 5)
                                .padding(.bottom, 0)
                            
                            RoundedRectangle(cornerRadius: 20)
                                .stroke()
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .overlay {
                                    HStack {
                                        TextField("Test", text: $newName)
                                            .padding(.leading)
                                        Spacer()
                                    }
                                }
                            
                            Text("Tageszeit")
                                .font(.footnote)
                                .foregroundStyle(.gray)
                                .padding(.leading, 15)
                                .padding(.top, 5)
                                .padding(.bottom, 0)
                            
                            RoundedRectangle(cornerRadius: 20)
                                .stroke()
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .overlay {
                                    HStack {
                                        Picker("", selection: $newMealtime) {
                                            ForEach(Mealtime.allCases, id: \.self) { mealtime in
                                                Text(mealtime.asString).tag(mealtime)
                                            }
                                        }
                                        .colorMultiply(Color.black)
                                        .padding(.leading, 5)
                                        Spacer()
                                    }
                                }
                        }
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        CustomPicker(newUnit: $newCalories, systemName: "flame", unit: "Kalorien", color: .red)
                        CustomPicker(newUnit: $newDuration, systemName: "clock", unit: "Dauer", color: .green)
                        
                        VStack {
                            HStack {
                                Image(systemName: "cellularbars")
                                Text("Schwere")
                            }
                            .foregroundStyle(.cyan)
                            
                            RoundedRectangle(cornerRadius: 20)
                                .stroke()
                                .frame(height: 50)
                                .foregroundStyle(.cyan)
                                .overlay {
                                    Picker("", selection: $newDifficulty) {
                                        ForEach(Difficulty.allCases, id: \.self) { diff in
                                            Text("\(diff.asString)").tag(diff)
                                        }
                                    }
                                    .colorMultiply(Color.black)
                                }
                        }
                    }
                    .padding()
                    
                    Divider()
                    
                    List {
                        Section(isExpanded: $instructionExpanding) {
                            ForEach(newInstructions) { instruction in
                                Text(instruction.step)
                            }
                            Button("Neuer Schritt") {
                                let instruction = Instruction(step: "New")
                                newInstructions.append(instruction)
                            }
                        } header: {
                            Text("Anleitung")
                        }
                    }
                    .listStyle(.insetGrouped)
                    .scrollContentBackground(.hidden)
                    
                    List {
                        Section(isExpanded: $ingredientsExpanding) {
                            ForEach(newIngredients) { ingredient in
                                Text(ingredient.name)
                            }
                            Button("Neuer Schritt") {
                                let ingredient = Ingredient(name: "Testingredient", amount: 1, unit: .gramm)
                                newIngredients.append(ingredient)
                            }
                        } header: {
                            Text("Zutat")
                        }
                    }
                    .listStyle(.insetGrouped)
                    .scrollContentBackground(.hidden)
                    
                    Spacer()
                    
                    Button {
                        let newRecipe = Recipe(name: newName, mealtime: newMealtime, ingredient: newIngredients, instructions: newInstructions, calories: newCalories, duration: newDuration, difficulty: newDifficulty, image: "\(selectedImage)", isFavorite: false)
                        context.insert(newRecipe)
                        dismiss()
                    } label: {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(height: 50)
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 50)
                            .foregroundStyle(.green)
                            .overlay {
                                Text("Rezept hinzufügen")
                                    .font(.title3)
                                    .bold()
                                    .foregroundStyle(.black)
                            }
                    }
                }
                .navigationTitle("Neues Rezept")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "arrow.left")
                                .padding()
                                .foregroundStyle(.black)
                        }
                    }
                }
            }
        }
    }
    private func colorForDuration(for duration: Int) -> Color {
        switch duration {
        case 0..<20: return .green
        case 20..<40: return .orange
        default: return .red
        }
    }
}

struct CustomPicker: View {
    
    @Binding var newUnit: Int
    
    let systemName: String
    let unit: String
    let color: Color
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: systemName)
                Text(unit)
            }
            .foregroundStyle(color)
            RoundedRectangle(cornerRadius: 20)
                .stroke()
                .frame(height: 50)
                .foregroundStyle(color)
                .overlay {
                    HStack {
                        Image(systemName: "minus")
                            .onTapGesture {
                                newUnit -= 1
                            }
                        Divider()
                        TextField("0", value: $newUnit, formatter: NumberFormatter())
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.center)
                        Divider()
                        Image(systemName: "plus")
                            .onTapGesture {
                                newUnit += 1
                            }
                    }
                    .padding(.horizontal, 5)
                }
        }
    }
}

#Preview {
    AddRecipeView()
}
