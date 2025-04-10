//
//  AllRecipesView.swift
//  TestListApp
//
//  Created by Michael Ilic on 03.04.25.
//

import SwiftUI


struct AllRecipesView: View {
    
    enum SortOption: String, CaseIterable {
        case name = "Name"
        case favorites = "Favoriten"
        case duration = "Dauer"
    }
    
    @State private var sortOption: SortOption = .name
    @State private var searchTextField: String = ""
    
    let recipes: [Recipe]
    
    var sortedRecipes: [Recipe] {
        switch sortOption {
        case .name:
            return recipes.sorted { $0.name < $1.name }
        case .favorites:
            return recipes.sorted { $0.isFavorite && !$1.isFavorite }
        case .duration:
            return recipes.sorted { $0.duration < $1.duration }
        }
    }
    
    var filteredAndSortedRecipes: [Recipe] {
        if searchTextField.isEmpty {
            return sortedRecipes
        } else {
            return sortedRecipes.filter { recipe in
                recipe.name.localizedCaseInsensitiveContains(searchTextField)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.blue.opacity(0.2)
                    .ignoresSafeArea()
                
                VStack(alignment: .leading) {
                    HStack {
                        TextField("Rezept finden", text: $searchTextField)
                            .padding()
                            .background {
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.gray.opacity(0.3))
                            }
                            .padding(.leading)
                            .padding(.vertical, 10)
                        
                        Menu {
                            ForEach(SortOption.allCases, id: \.self) { option in
                                Button {
                                    sortOption = option
                                } label: {
                                    Text(option.rawValue)
                                }
                            }
                        } label: {
                            Image(systemName: "arrow.up.arrow.down")
                                .padding()
                                .background {
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color.gray.opacity(0.3))
                                }
                                .padding(.trailing)
                                .padding(.vertical, 10)
                        }
                    }
                    
                    Text("Sortiert nach: \(sortOption.rawValue)")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                        .italic()
                        .padding(.leading)
                    
                    ScrollView(.vertical) {
                        LazyVStack(alignment: .leading, spacing: 10) {
                            
                            Divider()
                            
                            ForEach(filteredAndSortedRecipes, id: \.id) { recipe in
                                RecipeFoodCard(recipe: recipe)
                                Divider()
                            }
                        }
                    }
                }
            }
            .navigationTitle("Alle Speisen")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

//#Preview {
//    AllRecipesView(recipes: [Recipe(name: "", mealtime: <#T##Mealtime#>, ingredient: <#T##[Ingredient]#>, instructions: <#T##[Instruction]#>, calories: <#T##Int#>, duration: <#T##Int#>, difficulty: <#T##Difficulty#>, image: <#T##String#>, isFavorite: <#T##Bool#>)])
//}
