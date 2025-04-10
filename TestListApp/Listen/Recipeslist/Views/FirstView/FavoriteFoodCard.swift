//
//  FavoriteFoodCard.swift
//  TestListApp
//
//  Created by Michael Ilic on 03.04.25.
//

import SwiftUI

struct FavoriteFoodCard: View {
    
    @State private var showRecipeDetail = false
    
    @ObservedObject var recipe: Recipe
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(alignment: .leading, spacing: 5) {
//                Image("\(recipe.image)")
                Image("Essensbild")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 120)
                    .clipShape(UnevenRoundedRectangle(cornerRadii: .init(topLeading: 25, bottomLeading: 0, bottomTrailing: 0, topTrailing: 25), style: .continuous))
                    .clipped()
                
                Group {
                    Text(recipe.name)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    
                    HStack {
                        Text("\(recipe.mealtime.asString)")
                        
                        Spacer()
                        
                        Image(systemName: "clock")
                            .foregroundStyle(.gray)
                        Text("\(recipe.duration)min")
                            .foregroundStyle(.gray)
                    }
                    .font(.footnote)
                    .padding(.bottom)
                }
                .padding(.horizontal, 10)
            }
            .background {
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.white)
                    .shadow(color: .black, radius: 3, x: 2, y: 2)
            }
            .padding(.vertical, 10)
            .onTapGesture {
                showRecipeDetail = true
            }
            
            FavoriteButton(recipe: recipe)
                .padding(.top)
                .padding(.trailing, 8)
        }
        .fullScreenCover(isPresented: $showRecipeDetail) {
            RecipeDetailView(recipe: recipe)
        }
    }
}

//#Preview {
//    FavoriteFoodCard()
//}
