//
//  GroceryItemRowView.swift
//  TestListApp
//
//  Created by Michael Ilic on 07.04.25.
//

import SwiftUI

struct GroceryItemRowView: View {
    
    @State private var showSheet: Bool = false
    @State private var showCategorySheet: Bool = false
    
    @ObservedObject var item: GroceryItem
    
    @Environment(\.modelContext) private var context
    
    var body: some View {
        VStack {
            HStack {
                Text("") //Ohne dem verschwindet der durchgehende Strich unter jedem Item
                
                Circle()
                    .fill(item.supermarkt.color)
                    .frame(width: 15)
                    .onTapGesture {
                        showCategorySheet = true
                    }
                
                TextField("Neues Item hinzufügen", text: $item.name)
                    .strikethrough(item.isDone ? true : false)
                    .foregroundStyle(item.isDone ? .gray : .primary)
                
                Spacer()
                
                Button(action: { showSheet = true } ) {
                    Text("\(item.anzahl)\(item.unit.short)")
                }
                
                Image(systemName: item.isDone ? "checkmark.circle.fill" : "checkmark.circle")
                    .foregroundStyle(item.isDone ? .green : .primary)
                    .onTapGesture {
                        item.isDone.toggle()
                    }
            }
        }
        .sheet(isPresented: $showSheet) {
            ItemAnzahl(item: item)
                .presentationDetents([.fraction(0.4)])
                .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $showCategorySheet) {
            ChangeCategoryView(selectedSupermarkt: $item.supermarkt)
        }
    }
}

struct ChangeCategoryView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedSupermarkt: Supermarkt
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(Supermarkt.allCases, id: \.self) { supermarkt in
                    Text("\(supermarkt)".capitalized)
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 25)
                                .fill(supermarkt.color.opacity(0.5))
                        }
                        .padding(.leading)
                        .padding(.top)
                        .onTapGesture {
                            selectedSupermarkt = supermarkt
                            dismiss()
                        }
                }
            }
        }
        .scrollIndicators(.hidden)
        .presentationDetents([.fraction(0.2)])
        .presentationDragIndicator(.visible)
    }
}

struct ItemAnzahl: View {
    
    @ObservedObject var item: GroceryItem
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Spacer()
                    Text("\(item.anzahl)")
                    Divider()
                        .frame(height: 20)
                    Text(item.unit.asString)
                    Spacer()
                    Spacer()
                }
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 25)
                        .foregroundStyle(.secondary.opacity(0.3))
                        .frame(maxHeight: 30)
                }
                HStack {
                    Picker("", selection: $item.anzahl) {
                        ForEach(0..<1001) { zahl in
                            Text("\(zahl)")
                                .foregroundStyle(.primary)
                        }
                    }
                    .pickerStyle(.inline)
                    
                    Picker("", selection: $item.unit) {
                        ForEach(GroceryUnit.allCases, id: \.self) { einh in
                            Text("\(einh)".capitalized)
                        }
                    }
                    .pickerStyle(.inline)
                }
            }
            .navigationTitle(item.name)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    GroceryItemRowView(item: GroceryItem(name: "Apfel", supermarkt: .bipa, unit: .portion, anzahl: 1))
}
