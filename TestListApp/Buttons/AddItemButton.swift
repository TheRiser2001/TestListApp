//
//  AddItemButton.swift
//  TestListApp
//
//  Created by Michael Ilic on 28.03.24.
//

import SwiftUI

struct AddItemButton: View {
    
    let title: LocalizedStringKey
    
    var body: some View {
        Text(title)
            .foregroundStyle(.white)
            .font(.title2)
            .bold()
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .background(Color.blue.cornerRadius(25))
            .padding(.horizontal)
    }
}

#Preview {
    AddItemButton(title: "Test")
}
