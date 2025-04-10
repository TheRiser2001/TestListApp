//
//  EmptyWunschStateView.swift
//  TestListApp
//
//  Created by Michael Ilic on 10.04.24.
//

import SwiftUI

struct EmptyStateView: View {
    
    let sfSymbol: String
    let message: String
    
    var body: some View {
        VStack {
            Image(systemName: sfSymbol)
                .resizable()
                .scaledToFit()
                .frame(height: 150)
            
            Text(message)
                .font(.title3)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .padding()
        }
        .offset(y: -25)
    }
}

#Preview {
    EmptyStateView(sfSymbol: "star.fill", message: "Du hast im Moment keine View zum darstellen du Opfer.")
}
