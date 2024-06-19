//
//  MainTabView.swift
//  TestListApp
//
//  Created by Michael Ilic on 06.03.24.
//

import SwiftUI

struct MainTabView: View {
    
    @State private var backgroundColor: Color = .red
    
    var body: some View {
        TabView {
            MainListView(backgroundColor: $backgroundColor)
                .tabItem { Label("Home", systemImage: "pencil.and.list.clipboard") }
        }
    }
}

#Preview {
    MainTabView()
}
