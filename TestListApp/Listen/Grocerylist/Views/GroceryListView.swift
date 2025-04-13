//
//  GroceryListView.swift
//  TestListApp
//
//  Created by Michael Ilic on 07.04.25.
//

import SwiftData
import SwiftUI

struct GroceryListView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    @State private var categoryIdWithoutItems: UUID?
    @State private var showAddCategoryView: Bool = false
    @State private var alertDeleteCategory: Bool = false
    @State private var isEditing: Bool = false
    @State private var selectedSupermarkt: Supermarkt?
    
    @Query(sort: \GroceryCategory.createdAt, order: .forward) private var categories: [GroceryCategory]
    
    private var hasVisibleCategories: Bool {
        // Hier wird erstmal kontrolliert ob selectedSupermarkt nicht nil ist - also ob ein Supermarkt ausgewählt ist
        if let selectedSupermarkt = selectedSupermarkt {
            // Dann wird jede Kategorie durchsucht und es wird geschaut ob mindestens 1 Item existiert mit demselben Supermarkt wie ausgewählt -> true, ansonsten false
            return categories.contains { kategorie in
                kategorie.items.contains { $0.supermarkt == selectedSupermarkt }
            }
        } else {
            // Hier wird überprüft ob es überhaupt kategorien gibt - Wenn die Liste nicht leer ist -> true, ansonsten false
            return !categories.isEmpty
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                VStack {
                    if categories.isEmpty {
                        ContentUnavailableView("Füge Artikel für deinen nächsten Einkauf hinzu!", systemImage: "cart")
                    } else {
                        ScrollView(.horizontal) {
                            HStack {
                                Text("Alle")
                                    .bold()
                                    .padding()
                                    .background {
                                        RoundedRectangle(cornerRadius: 25)
                                            .fill(selectedSupermarkt == nil ? Color.cyan : Color.cyan.opacity(0.4))
                                    }
                                    .padding(.top)
                                    .onTapGesture {
                                        selectedSupermarkt = nil
                                    }
                                
                                ForEach(Supermarkt.allCases, id: \.self) { supermarkt in
                                    getSelectedSupermarkt(supermarkt: supermarkt)
                                }
                            }
                            .padding(.horizontal)
                        }
                        .scrollIndicators(.hidden)
                        
                        if hasVisibleCategories {
                            List {
                                ForEach(categories, id: \.id) { category in
                                    if shouldShowSection(for: category) {
                                        GrocerySectionRowView(categoryIdWithoutItems: $categoryIdWithoutItems, category: category, selectedSupermarkt: selectedSupermarkt)
                                    }
                                }
                            }
                            .listStyle(.sidebar)
                            .environment(\.editMode, .constant(self.isEditing ? EditMode.active : EditMode.inactive).animation(.spring))
                            .onChange(of: categoryIdWithoutItems) { _, newVal in
                                if newVal != nil {
                                    alertDeleteCategory = true
                                }
                            }
                        } else {
                            ContentUnavailableView("Du musst heute nicht in diesen Supermarkt", systemImage: "face.smiling")
                        }
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
                        showAddCategoryView = true
                    }
                    .padding(.trailing)
            }
            .background(Color(.systemGray6))
            
            .toolbar{
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isEditing.toggle()
                    } label: {
                        HStack {
                            Image(systemName: isEditing ? "pencil" : "pencil")
                            Text(isEditing ? "Done" : "Edit")
                        }
                        .foregroundStyle(Color.white)
                        .padding(.vertical, 5)
                        .padding(.horizontal)
                        .background {
                            Capsule()
                                .tint(Color.black.opacity(0.4))
                        }
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Text("X")
                    .foregroundStyle(Color.white)
                    .padding(8)
                    .background {
                        Circle()
                            .tint(Color.black.opacity(0.4))
                    }
                }
                }
            }
            .navigationTitle("Einkaufsliste")
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color.green, for: .navigationBar)
            
            .sheet(isPresented: $showAddCategoryView) {
                AddCategoryView(selectedSupermarkt: selectedSupermarkt)
                    .presentationDetents([.fraction(0.7)])
                    .presentationDragIndicator(.visible)
            }
        }
        .alert("Kategorie löschen?", isPresented: $alertDeleteCategory) {
            Button("Delete", role: .destructive) {
                if let index = categories.firstIndex(where: { $0.id == categoryIdWithoutItems }) {
                    deleteCategory(at: IndexSet(integer: index))
                    categoryIdWithoutItems = nil
                }
                do {
                    try context.save()
                } catch {
                    print("Fehler beim löschen der Kategorie: \(error)")
                }
            }
        } message: {
            Text("Die Kategorie und alle dazugehörigen Einträge werden gelöscht.")
        }
    }
    
    private func deleteCategory(at offSets: IndexSet) {
        for index in offSets {
            let category = categories[index]
            context.delete(category)
        }
    }
    
    private func shouldShowSection(for category: GroceryCategory) -> Bool {
        if let selectedSupermarkt = selectedSupermarkt {
            return category.items.contains { $0.supermarkt == selectedSupermarkt }
        } else {
            return true
        }
    }
    
    @ViewBuilder
    func getSelectedSupermarkt(supermarkt: Supermarkt) -> some View {
        if selectedSupermarkt == supermarkt {
            Text("\(supermarkt)".capitalized)
                .bold()
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(supermarkt.color)
                }
                .padding(.leading)
                .padding(.top)
                .onTapGesture {
                    selectedSupermarkt = supermarkt
                }
        } else {
            Text("\(supermarkt)".capitalized)
                .bold()
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(supermarkt.color.opacity(0.4))
                }
                .padding(.leading)
                .padding(.top)
                .onTapGesture {
                    selectedSupermarkt = supermarkt
                }
        }
    }
    
//    @ViewBuilder
//    func dismissButton() -> some View {
//        Button {
//            dismiss()
//        } label: {
//            Image(systemName: "xmark")
//                .imageScale(.small)
//                .frame(width: 44, height: 44)
//                .foregroundStyle(.white)
//                .background {
//                    Circle()
//                        .frame(width: 30, height: 30)
//                        .tint(Color.black.opacity(0.4))
//                }
//        }
//    }
}

struct GrocerySectionRowView: View {
    
    @Environment(\.modelContext) private var context
    
    @State private var isExpanded: Bool = true
    @Binding var categoryIdWithoutItems: UUID?
    
    var category: GroceryCategory
    var selectedSupermarkt: Supermarkt?
    
    
    var body: some View {
        Section(isExpanded: $isExpanded) {
            ForEach(category.items.filter { item in
                selectedSupermarkt == nil || item.supermarkt == selectedSupermarkt
            }, id: \.id) { item in
                GroceryItemRowView(item: item)
            }
            .onDelete { offSet in
                category.items.remove(atOffsets: offSet)
                if category.items.isEmpty {
                    categoryIdWithoutItems = category.id
                }
            }
            
            Button {
                let newItem = GroceryItem(name: "", supermarkt: selectedSupermarkt ?? .billa, unit: .portion, anzahl: 1, isDone: false)
                withAnimation {
                    //WICHTIG: Hier wird beides benötigt, da Swiftdata sonst nicht weiß zu welchem Model es inserten soll
                    category.items.append(newItem)
                    context.insert(newItem)
                }
            } label: {
                Label("Neuer Artikel", systemImage: "plus")
                    .foregroundStyle(.blue)
            }
        } header: {
            Text("\(category.name): \(category.items.filter{ selectedSupermarkt == nil || $0.supermarkt == selectedSupermarkt }.count)")
        }
    }
}


#Preview {
    GroceryListView()
}
