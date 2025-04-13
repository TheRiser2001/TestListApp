//
//  RecipesView.swift
//  TestListApp
//
//  Created by Michael Ilic on 03.04.25.
//

import SwiftData
import SwiftUI

struct RecipesView: View {
    
    @Environment(\.dismiss) var dismiss
    
    //    @State private var recipes: [Recipe] = [
    //        Recipe(name: "Avocado Sandwich", mealtime: .breakfast, ingredient: [], instructions: [], calories: 200, duration: 50, difficulty: .easy, image: "Essensbild", isFavorite: false),
    //        Recipe(name: "Hühnchen mit Nudeln", mealtime: .lunch, ingredient: [Ingredient(name: "Huhn", amount: 1, unit: .anzahl), Ingredient(name: "Reis", amount: 3, unit: .gramm)], instructions: [], calories: 500, duration: 15, difficulty: .hard, image: "Essensbild", isFavorite: true),
    //        Recipe(name: "Hühnchen mit Reis", mealtime: .lunch, ingredient: [Ingredient(name: "Huhn", amount: 1, unit: .anzahl), Ingredient(name: "Reis", amount: 3, unit: .gramm)], instructions: [], calories: 500, duration: 15, difficulty: .hard, image: "Essensbild", isFavorite: false),
    //        Recipe(name: "Rindfleisch mit Kartoffeln", mealtime: .dinner, ingredient: [Ingredient(name: "Huhn", amount: 1, unit: .anzahl), Ingredient(name: "Reis", amount: 3, unit: .gramm)], instructions: [], calories: 500, duration: 15, difficulty: .intermediate, image: "Essensbild", isFavorite: true)
    //    ]
    @State private var selectedMealtime: Mealtime?
    @State private var showAllRecipes = false
    @State private var showAddRecipeView = false
    
    @Query private var recipes: [Recipe]
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                if recipes.isEmpty {
                    ContentUnavailableView("Füge dein erstes Rezept hinzu!", systemImage: "fork.knife")
                } else {
                    VStack {
                        Text("Was würden Sie heute gerne kochen?")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.vertical)
                        
                        HStack {
                            Text("Favoriten")
                                .font(.headline)
                                .bold()
                            Spacer()
                            Text("Alle sehen")
                                .font(.subheadline)
                                .fontWeight(.thin)
                                .onTapGesture {
                                    showAllRecipes = true
                                }
                        }
                        .padding(.horizontal)

                        recipeFavorites()
                        
                        allCategories()
                        
                        ScrollView(.vertical) {
                            LazyVStack(alignment: .leading, spacing: 10) {
                                filteredRecipeView()
                            }
                        }
                        Spacer()
                    }
                }
                
                Text("+")
                    .font(.system(size: 50))
                    .foregroundStyle(.white)
                    .padding()
                    .padding(.bottom, 4)
                    .padding(.leading, 1)
                    .background {
                        Circle()
                            .fill(.blue)
                    }
                    .onTapGesture {
                        showAddRecipeView.toggle()
                    }
                    .padding()
            }
            
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button { dismiss } label: {
                        Image(systemName: "xmark.circle")
                            .foregroundStyle(.white)
                    }
                }
            }
            .navigationTitle("Rezepte")
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color.blue, for: .navigationBar)
            .ignoresSafeArea(edges: .bottom)
            .background(Color.orange.opacity(0.2))
        }
        
        .sheet(isPresented: $showAllRecipes) {
            AllRecipesView(recipes: recipes)
                .presentationDetents([.fraction(0.9)])
                .presentationDragIndicator(.visible)
        }
        .fullScreenCover(isPresented: $showAddRecipeView) {
            AddRecipeView()
        }
    }
    
    @ViewBuilder
    private func getSelectedMealtime(mealtime: Mealtime) -> some View {
        if selectedMealtime == mealtime {
            Text(mealtime.asString)
                .foregroundStyle(.black)
                .padding(.horizontal)
                .padding(.vertical, 5)
                .background {
                    Capsule()
                        .fill(Color.green.opacity(0.5))
                }
                .onTapGesture {
                    selectedMealtime = mealtime
                }
        } else {
            Text(mealtime.asString)
                .foregroundStyle(.black)
                .padding(.horizontal)
                .padding(.vertical, 5)
                .background {
                    Capsule()
                        .fill(Color.yellow.opacity(0.5))
                }
                .onTapGesture {
                    selectedMealtime = mealtime
                }
        }
    }
    
    @ViewBuilder
    func recipeFavorites() -> some View {
        let recipeFavorites = recipes.filter {$0.isFavorite}
        
        if recipeFavorites.isEmpty {
            ContentUnavailableView("Du hast noch keine Favoriten ausgewählt", systemImage: "star.fill")
                .frame(maxHeight: 210)
        } else {
            ScrollView(.horizontal) {
                LazyHStack(alignment: .top, spacing: 15) {
                    ForEach(recipeFavorites) { recipe in
                        FavoriteFoodCard(recipe: recipe)
                    }
                }
            }
            .padding(.horizontal)
            .frame(maxHeight: 210)
            .scrollIndicators(.hidden)
        }
    }
    
    @ViewBuilder
    func allCategories() -> some View {
        ScrollView(.horizontal) {
            LazyHStack(alignment: .top, spacing: 15) {
                
                Text("Alle Speisen")
                    .foregroundStyle(Color.black)
                    .padding(.horizontal)
                    .padding(.vertical, 5)
                    .background {
                        Capsule()
                            .fill(selectedMealtime == nil ? Color.green.opacity(0.5) : Color.yellow.opacity(0.5))
                    }
                    .onTapGesture {
                        selectedMealtime = nil
                    }
                
                ForEach(Mealtime.allCases, id: \.self) { mealtime in
                    getSelectedMealtime(mealtime: mealtime)
                }
            }
            .padding(.horizontal)
        }
        .frame(maxHeight: 35)
        .scrollIndicators(.hidden)
    }
    
    @ViewBuilder
    func filteredRecipeView() -> some View {
        let filteredRecipes = recipes.filter { recipe in
            selectedMealtime == nil || recipe.mealtime == selectedMealtime
        }
        
        Divider()
        
        if filteredRecipes.isEmpty {
            ContentUnavailableView("Du hast für diese Tageszeit noch keine Rezepte", systemImage: "fork.knife")
        } else {
            //            List {
            ForEach(filteredRecipes, id: \.id) { recipe in
                if selectedMealtime == nil || recipe.mealtime == selectedMealtime {
                    RecipeFoodCard(recipe: recipe)
                    //                        }
                    Divider()
                }
            }
        }
    }
    
}

#Preview {
    RecipesView()
}
