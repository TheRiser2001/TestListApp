//
//  FavoriteButton.swift
//  TestListApp
//
//  Created by Michael Ilic on 03.04.25.
//

import SwiftUI

struct FavoriteButton: View {
    
    @ObservedObject var recipe: Recipe
    
    var body: some View {
        Button {
            recipe.isFavorite.toggle()
        } label: {
            Circle()
                .fill(.white)
                .frame(width: 30)
                .overlay {
                    Image(systemName: recipe.isFavorite ? "star.fill" : "star")
                        .foregroundStyle(recipe.isFavorite ? Color.yellow : Color.black)
                }
        }
    }
}

//#Preview {
//    FavoriteButton()
//}
