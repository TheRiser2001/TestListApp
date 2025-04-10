//
//  RecipeEditView.swift
//  TestListApp
//
//  Created by Michael Ilic on 03.04.25.
//

import SwiftUI

struct RecipeEditView: View {
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @Binding var pickerState: String
    @Binding var showEditView: Bool
    
    @ObservedObject var recipe: Recipe
    
    var zeitFarbe: (Int) -> Color
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(alignment: .leading) {
                Group {
                    HStack {
                        VStack(alignment: .leading) {
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
                                        TextField("Test", text: $recipe.name)
                                            .padding(.leading)
                                        Spacer()
                                    }
                                }
                        }
                        
                        VStack(alignment: .leading) {
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
                                        Picker("Test", selection: $recipe.mealtime) {
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
                    HStack {
                        CustomPicker(newUnit: $recipe.calories, systemName: "flame", unit: "Kalorien", color: .red)
                        CustomPicker(newUnit: $recipe.duration, systemName: "clock", unit: "Dauer", color: zeitFarbe(recipe.duration))
//                            .foregroundStyle(zeitFarbe(recipe.duration))
                        
                        VStack {
                            HStack {
                                Image(systemName: "cellularbars")
                                Text("Schwere")
                            }
                            
                            RoundedRectangle(cornerRadius: 20)
                                .stroke()
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .overlay {
                                    Picker("", selection: $recipe.difficulty) {
                                        ForEach(Difficulty.allCases, id: \.self) { diff in
                                            Text("\(diff.asString)").tag(diff)
                                        }
                                    }
                                    .colorMultiply(Color.black)
                                }
                        }
                        .foregroundStyle(recipe.difficulty.color)
                    }
                    .padding(.top)
                    .padding(.bottom)
                }
                .padding(.horizontal)
                
                Picker("", selection: $pickerState) {
                    Text("Zutaten").tag("zutaten")
                    Text("Anleitung").tag("anleitung")
                }
                .pickerStyle(.segmented)
                
                if pickerState == "anleitung" {
                    InstructionPickerView(recipe: recipe)
                } else {
                    IngredientPickerView(showEditView: $showEditView, recipe: recipe)
                }
            }
            deleteButton()
        }
    }
    
    @ViewBuilder
    private func deleteButton() -> some View {
        Button {
            context.delete(recipe)
            dismiss()
        } label: {
            RoundedRectangle(cornerRadius: 10)
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .foregroundStyle(.red)
                .padding(.horizontal)
                .overlay {
                    Text("Rezept löschen")
                        .font(.title3)
                        .bold()
                        .foregroundStyle(.black)
                }
        }
    }
}

//#Preview {
//    RecipeEditView(test: .constant("Test"), showEditView: .constant(false), rezept: Rezept(name: "test", tageszeit: .frühstück, zutaten: [], calorien: 200, dauer: 5, schwierigkeit: .leicht, image: "", isFavorite: false), zeitFarbe: Color.green)
//    RecipeEditView(pickerState: .constant("Leicht"), showEditView: .constant(.true), recipe: Recipe(name: "test", tageszeit: .frühstück, zutaten: [], calorien: 200, dauer: 5, schwierigkeit: .leicht, image: "", isFavorite: false), zeitFarbe:)
//}
