//
//  MainTabView.swift
//  TestListApp
//
//  Created by Michael Ilic on 06.03.24.
//

import SwiftUI

struct MainTabView: View {
    
    var body: some View {
        TabView {
            MainListView()
                .tabItem { Label("Home", systemImage: "pencil.and.list.clipboard") }
        }
    }
}

#Preview {
    MainTabView()
}
