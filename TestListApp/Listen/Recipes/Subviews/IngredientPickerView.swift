//
//  IngredientPickerView.swift
//  TestListApp
//
//  Created by Michael Ilic on 03.04.25.
//

import SwiftUI

struct IngredientPickerView: View {
    
    @Binding var showEditView: Bool
    @ObservedObject var recipe: Recipe
    
    var body: some View {
        VStack {
            Button {
                withAnimation {
                    let newIngredient = Ingredient(name: "Testzutat", amount: 1, unit: .liter)
                    recipe.ingredient.append(newIngredient)
                }
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .foregroundStyle(.green)
                    
                    Text("Zutat hinzufügen")
                        .foregroundStyle(.black)
                        .fontWeight(.medium)
                }
                .padding(.horizontal)
            }
        }
        ScrollView(.vertical) {
            ForEach($recipe.ingredient, id: \.id) { ingredient in
                if showEditView {
                    HStack {
                        IngredientDetail(ingredient: ingredient)
                        Button {
                            withAnimation {
                                deleteIngredient(where: ingredient.id)
                            }
                        } label: {
                            Label("", systemImage: "minus.circle")
                                .font(.system(size: 20))
                                .foregroundStyle(.red)
                                .padding(.trailing)
                        }
                    }
                } else {
                    IngredientDetail(ingredient: ingredient)
                }
            }
        }
    }
    func deleteIngredient(where id: UUID) {
        recipe.ingredient.removeAll(where: { $0.id == id })
    }
}

struct IngredientDetail: View {
    
    @State private var showIngredientChange = false
    
    @Binding var ingredient: Ingredient
    
    var body: some View {
        HStack {
            Text(ingredient.name)
            Spacer()
            Text("\(ingredient.amount)\(ingredient.unit.short)")
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 25)
                .foregroundStyle(.gray.opacity(0.5))
        }
        .padding(.horizontal)
        .onTapGesture {
            showIngredientChange = true
        }
        .sheet(isPresented: $showIngredientChange) {
            IngredientChangeView(ingredient: $ingredient)
                .presentationDetents([.fraction(0.35)])
                .presentationDragIndicator(.visible)
        }
    }
}

struct IngredientChangeView: View {
    
    // Das wird verwendet um die View neu zu laden damit sobald .gramm ausgewählt ist der wert auf 100 gesetzt wird
    @State private var refreshView = false
    
    @Binding var ingredient: Ingredient
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    TextField("", text: $ingredient.name)
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundStyle(.gray.opacity(0.3))
                        }
                    Spacer()
                    
                    Text("\(ingredient.amount) \(ingredient.unit.short)")
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundStyle(.gray.opacity(0.3))
                        }
                }
                .padding(.horizontal)
                
                HStack {
                    Picker("", selection: $ingredient.amount) {
                        ForEach(0..<1000, id: \.self) { amount in
                            Text("\(amount)").tag(amount)
                        }
                    }
                    .onChange(of: ingredient.unit) { _, newUnit in
                        if newUnit == .gramm {
                            ingredient.amount = 100
                        } else if newUnit == .milliliter {
                            ingredient.amount = 100
                        } else {
                            ingredient.amount = 1
                        }
                        refreshView.toggle()
                    }
                    .id(refreshView)
                    
                    Picker("", selection: $ingredient.unit) {
                        ForEach(Unit.allCases, id: \.self) { unit in
                            Text(unit.asString).tag(unit)
                        }
                    }
                }
                .pickerStyle(.wheel)
            }
            .navigationTitle("Details")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    IngredientPickerView(showEditView: .constant(false), recipe: Recipe(name: "Test", mealtime: .breakfast, ingredient: [], instructions: [], calories: 200, duration: 15, difficulty: .easy, image: "", isFavorite: true))
}
