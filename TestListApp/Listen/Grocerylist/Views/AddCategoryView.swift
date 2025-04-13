//
//  AddCategoryView.swift
//  TestListApp
//
//  Created by Michael Ilic on 07.04.25.
//

import SwiftData
import SwiftUI

struct AddCategoryView: View {
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @State private var kategorien: [GroceryCategory] = [
        GroceryCategory(name: "Getränke", items: [], systemName: "drop"),
        GroceryCategory(name: "Essen", items: [], systemName: "fork.knife"),
        GroceryCategory(name: "Obst", items: [], systemName: "apple.logo"),
        GroceryCategory(name: "Gemüse", items: [], systemName: "carrot"),
        GroceryCategory(name: "Fleisch", items: [], systemName: "dumbbell"),
        GroceryCategory(name: "Milchprodukte", items: [], systemName: "drop"),
        GroceryCategory(name: "Haushalt", items: [], systemName: "house"),
        GroceryCategory(name: "Süßigkeiten", items: [], systemName: "birthday.cake"),
        GroceryCategory(name: "Party", items: [], systemName: "party.popper"),
        GroceryCategory(name: "Spielzeug", items: [], systemName: "gamecontroller"),
        GroceryCategory(name: "Medikament", items: [], systemName: "cross.case"),
        GroceryCategory(name: "Haustier", items: [], systemName: "dog"),
        GroceryCategory(name: "Kleidung", items: [], systemName: "tshirt"),
        GroceryCategory(name: "Technik", items: [], systemName: "wifi")
    ]
    @State private var textFieldText = ""
    
    let columns = [GridItem(), GridItem()]
    var selectedSupermarkt: Supermarkt?
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                LazyVGrid(columns: columns) {
                    ForEach(kategorien, id: \.id) { kategorie in
                        SingleCategory(text: kategorie.name, systemName: kategorie.systemName ?? "")
                            .onTapGesture {
                                addCategory(name: kategorie.name)
                            }
                    }
                    
                    TextField("Eigene...", text: $textFieldText)
                        .padding()
                        .background {
                            Capsule()
                                .stroke()
                        }
                    
                    if textFieldText != "" {
                        Button {
                            addCategory(name: textFieldText)
                        } label: {
                            Capsule()
                                .fill(.blue)
                                .frame(height: 50)
                                .overlay {
                                    Text("Hinzufügen")
                                        .foregroundStyle(.white)
                                        .font(.title3)
                                        .bold()
                                }
                        }
                    }
                }
            }
            .padding(.horizontal)
            .navigationTitle("Kategorien")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    func addCategory(name: String) {
        let newCategory = GroceryCategory(name: name, items: [GroceryItem(name: "", supermarkt: selectedSupermarkt ?? .billa, anzahl: 1)])
        context.insert(newCategory)
        dismiss()
    }
}

struct SingleCategory: View {
    
    @State private var isSelected: Bool = false
    
    let text: String
    let systemName: String
    
    var body: some View {
        HStack {
            Spacer()
            Image(systemName: systemName)
            Text(text)
            Spacer()
        }
        .padding()
        .background {
            Capsule()
                .stroke()
        }
    }
}

#Preview {
    AddCategoryView()
}
