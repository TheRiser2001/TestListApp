//
//  RecipeFoodCard.swift
//  TestListApp
//
//  Created by Michael Ilic on 03.04.25.
//

import SwiftUI

struct RecipeFoodCard: View {
    
    @State private var showRecipeDetail = false
    
    @ObservedObject var recipe: Recipe
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            HStack(alignment: .top) {
//                Image("\(recipe.image)")
                Image("Essensbild")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                
                VStack(alignment: .leading) {
                    Text(recipe.name)
                    
                    Spacer()
                    
                    Text("\(recipe.mealtime.asString)")
                        .font(.callout)
                    
                    Spacer()
                    
                    HStack {
                        Image(systemName: "clock")
                        Text("\(recipe.duration)min")
                        Spacer()
                        Text("\(recipe.ingredient.count) Zutaten")
                            .padding(.trailing)
                    }
                    .foregroundStyle(.gray)
                    .font(.footnote)
                }
                .padding(.vertical, 5)
            }
            .padding(.leading)
            .onTapGesture {
                showRecipeDetail = true
            }
            
            FavoriteButton(recipe: recipe)
                .padding(.trailing)
        }
        .fullScreenCover(isPresented: $showRecipeDetail) {
            RecipeDetailView(recipe: recipe)
        }
    }
}

//#Preview {
//    RecipeFoodCard()
//}
