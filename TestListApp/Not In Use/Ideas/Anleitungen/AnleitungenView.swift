//
//  AnleitungenView.swift
//  TestListApp
//
//  Created by Michael Ilic on 26.03.24.
//

import SwiftUI

struct Kategorien {
    
}

struct Aufgaben {
    
}

struct AnleitungenView: View {
    
    let listInfo: ListInfo
    
    var body: some View {
        NavigationStack {
            List {
                Section("") {
                    NavigationLink {
                        KategorieView(title: "Haushalt")
                    } label: {
                        HStack {
                            Image(systemName: "house")
                            Text("Haushalt")
                        }
                    }
                    
                    NavigationLink {
                        InhaltView(title: "Arbeit")
                    } label: {
                        HStack {
                            Image(systemName: "laptopcomputer")
                            Text("Arbeit")
                        }
                    }
                }
            }
            .navigationTitle("Anleitungen")
            
            .toolbarBackground(listInfo.backgroundColor.opacity(0.6), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        
                    } label: {
                        Image(systemName: "plus.circle")
                    }
                    
                }
            }
        }
        .listStyle(.insetGrouped)
    }
}

struct KategorieView: View {
    
    let title: String
    
    var body: some View {
        Form {
            NavigationLink("Wäsche waschen") {
                InhaltView(title: "Wäsche waschen")
            }
            .navigationTitle(title)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button("Was anderes hinzufügen") {
                        
                    }
                    
                    Button("Irgendwas hinzufügen") {
                        
                    }
                    
                } label: {
                    Image(systemName: "plus.circle")
                }
                
            }
        }
    }
}

struct InhaltView: View {
    
    @State private var anzahlZeile: [Int] = [1]
    @State private var items: [String] = ["1"]
    @State private var test = 1
    
    let title: String
    
    var body: some View {
        List {
            ForEach(items, id: \.self) { item in
                HStack(alignment: .top) {
                    Text(item)
                        .padding(.all, 7)
                    Divider()
                    TextFieldView()
                }
            }
            .onDelete(perform: deleteItem)
        }
        .listStyle(.insetGrouped)
        .navigationTitle(title)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    addItem()
                } label: {
                    Image(systemName: "plus.circle")
                }
                
            }
        }
    }
    
    func addItem() {
        let newItem = "\(items.count + 1)"
        items.append(newItem)
    }
    
    func deleteItem(indexSet: IndexSet) {
        items.remove(atOffsets: indexSet)
    }
}

struct TextFieldView: View {
    
    @State private var textFieldText: String = ""
    
    var body: some View {
        
        HStack {
            TextField("", text: $textFieldText, axis: .vertical)
                .lineLimit(99)
                .padding(.top, 7)
        }
    }
}

//#Preview {
//    AnleitungenView(listInfo: ListInfo(listName: "", systemName: "cart", backgroundColor: .blue, accentColor: .black))
//}
