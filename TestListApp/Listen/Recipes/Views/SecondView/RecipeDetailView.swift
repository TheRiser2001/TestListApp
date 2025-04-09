//
//  RecipeDetailView.swift
//  TestListApp
//
//  Created by Michael Ilic on 03.04.25.
//

import SwiftUI

struct RecipeDetailView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var pickerState = "zutaten"
    @State private var showEditView = false
    
    @ObservedObject var recipe: Recipe
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 10) {
//                Image(recipe.image)
                Image("Essensbild")
                    .resizable()
                    .frame(height: 300)
                    .frame(maxWidth: .infinity)
                    .scaledToFit()
                    .overlay {
                        VStack {
                            HStack {
                                Button {
                                    dismiss()
                                } label: {
                                    Image(systemName: "arrow.left")
                                        .padding()
                                        .foregroundStyle(.black)
                                        .background {
                                            Circle()
                                                .fill(Color.white)
                                                .frame(width: 30)
                                        }
                                }
                                Spacer()
                                FavoriteButton(recipe: recipe)
                                Button {
                                    withAnimation {
                                        showEditView.toggle()
                                    }
                                } label: {
                                    Circle()
                                        .fill(.white)
                                        .frame(width: 30)
                                        .overlay {
                                            Image(systemName: showEditView ? "pencil.slash" : "pencil")
                                                .foregroundStyle(Color.black)
                                        }
                                }
                            }
                            .padding(.top, 50)
                            .padding(.horizontal)
                            Spacer()
                        }
                    }
                
                if showEditView {
                    RecipeEditView(pickerState: $pickerState, showEditView: $showEditView, recipe: recipe, zeitFarbe: colorForDuration)
                } else {
                    Group {
                        Text(recipe.name)
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("\(recipe.mealtime.asString)")
                            .font(.subheadline)
                            .fontWeight(.thin)
                        
                        HStack {
                            Image(systemName: "flame.fill")
                                .foregroundStyle(.red)
                            Text("\(recipe.calories) kcal")
                                .foregroundStyle(.red)
                            Spacer()
                            Image(systemName: "clock")
                                .foregroundStyle(colorForDuration(for: recipe.duration))
                            Text("\(recipe.duration)min")
                                .foregroundStyle(colorForDuration(for: recipe.duration))
                            Spacer()
                            Image(systemName: "cellularbars")
                                .foregroundStyle(recipe.difficulty.color)
                            Text("\(recipe.difficulty.asString)")
                                .foregroundStyle(recipe.difficulty.color)
                        }
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
                
                Spacer()
            }
            .ignoresSafeArea(edges: .top)
        }
        .background(Color.blue.opacity(0.2))
        .scrollContentBackground(.hidden)
    }
    
    private func colorForDuration(for duration: Int) -> Color {
        switch duration {
        case 0..<20: return .green
        case 20..<40: return .orange
        default: return .red
        }
    }
}


#Preview {
    RecipeDetailView(recipe: Recipe(name: "Toast", mealtime: .breakfast, ingredient: [], instructions: [], calories: 820, duration: 1, difficulty: .intermediate, image: "Testbild", isFavorite: true))
}
