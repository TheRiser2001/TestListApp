//
//  MainListView.swift
//  TestListApp
//
//  Created by Michael Ilic on 02.02.24.
//

import SwiftUI

struct ListInfo: Identifiable {
    let id = UUID()
    let listName: String
    let systemName: String
    let itemsName: String
    let backgroundColor: Color
    var accentColor: Color
}

enum Destination {
    case einkaufen
    case todo
    case wünsche
    case geschenke
    case rezepte
    case anleitung
    case kalender
    case ausgabenrechner
}

struct MainListView: View {
    
    @State private var liste: [ListInfo] = [
        ListInfo(listName: "Einkaufen", systemName: "cart", itemsName: "Artikel", backgroundColor: .hellgrün, accentColor: .black),
        ListInfo(listName: "Todo", systemName: "cart", itemsName: "Todos", backgroundColor: .silber, accentColor: .black),
        ListInfo(listName: "Wünsche", systemName: "cart", itemsName: "Träume", backgroundColor: .tuerkis, accentColor: .black),
        ListInfo(listName: "Geschenke", systemName: "cart", itemsName: "Geschenke", backgroundColor: .pink, accentColor: .black),
        ListInfo(listName: "Rezepte", systemName: "cart", itemsName: "Rezepte", backgroundColor: .orange, accentColor: .black)
//        ListInfo(listName: "Anleitungen", systemName: "cart", itemsName: "Anleitungen", backgroundColor: .tan, accentColor: .black),
//        ListInfo(listName: "Alle Jahre wieder", systemName: "cart", itemsName: "Termine", backgroundColor: .magenta, accentColor: .white),
//        ListInfo(listName: "Ausgabenrechner", systemName: "cart", itemsName: "Ausgaben", backgroundColor: .navy, accentColor: .white)
    ]
    @State private var newTitle: String = ""
    @State private var isPresented: Bool = false
    @State private var accentColor: Color = .black
    @State private var destination: Destination? = nil
    
    @State private var selectedActivity: Ereignis?
    @State private var selectedListe: ListInfo?
    
    var body: some View {
        NavigationStack {
            List {
//                LazyVGrid(columns: Array(repeating: GridItem(), count: 2)) {
                    ForEach(liste) { listInfo in
                        NavigationLink(
                            destination: destinationView(for: listInfo),
                            tag: destination(for: listInfo),
                            selection: $destination
                        ) {
                            CardView(listInfo: listInfo)
                        }
                        .listRowSeparator(.hidden)
                    }
                    .onDelete { indices in
                        liste.remove(atOffsets: indices)
                    }
                    .onMove { indices, newOffset in
                        liste.move(fromOffsets: indices, toOffset: newOffset)
                    }
//                }
            }
            .navigationTitle("Listen")
            //MARK: AddView ist daweil auskommentiert
            //            .sheet(isPresented: $isPresented, content: {
            //                AddListe(cardColor: $liste, isPresented: $isPresented, accentColor: $accentColor, backgroundColor: $backgroundColor)
            //                    .presentationDetents([.fraction(0.8)])
            //            })
        }
        .tint(.black)
        
        .listStyle(.plain)
//        .onChange(of: backgroundColor) { _, newValue in
//            liste.indices.forEach { index in
//                liste[index].accentColor = Theme.accentColor(for: newValue)
//            }
//        }
    }
    
    func destination(for listInfo: ListInfo) -> Destination {
        switch listInfo.listName {
        case "Einkaufen": return .einkaufen
        case "Todo": return .todo
        case "Wünsche": return .wünsche
        case "Geschenke": return .geschenke
        case "Rezepte": return .rezepte
//        case "Anleitungen": return .anleitung
//        case "Alle Jahre wieder": return .kalender
//        case "Ausgabenrechner": return .ausgabenrechner
        default: return .einkaufen
        }
    }
    
    func destinationView(for listInfo: ListInfo) -> some View {
        switch destination(for: listInfo) {
        case .einkaufen:
            return AnyView(GroceryListView())
        case .todo:
            return AnyView(Todolist())
        case .wünsche:
            return AnyView(WishlistView())
        case .geschenke:
            return AnyView(PresentView())
        case .rezepte:
            return AnyView(RecipesView())
        case .anleitung:
            return AnyView(AnleitungenView(listInfo: listInfo))
        case .kalender:
            return AnyView(KalendarView())
        case .ausgabenrechner:
            return AnyView(AusgabenView(listInfo: listInfo))
        }
    }
    
}

struct CardView: View {
    
    let listInfo: ListInfo
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: listInfo.systemName)
                    .foregroundStyle(listInfo.backgroundColor)
                Text(listInfo.listName)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(listInfo.backgroundColor)
                Spacer()
            }
            Text("0 \(listInfo.itemsName)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity)
//        .frame(height: 130)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .stroke()
                .foregroundStyle(listInfo.backgroundColor)
        }
    }
}

//MARK: Funktioniert, daweil ist die funktion aber raus das man listen selbst hinzufügen kann
//struct AddListe: View {
//    
//    @Environment(\.modelContext) var context
//    @State private var textFieldText: String = ""
//    @State private var selectedColor: Color?
//    @Binding var cardColor: [ListInfo]
//    @Binding var isPresented: Bool
//    @Binding var accentColor: Color
//    @Binding var backgroundColor: Color
//    
//    var body: some View {
//        NavigationStack {
//            VStack {
//                Section("Liste") {
//                    TextField("Name der Liste", text: $textFieldText)
//                        .frame(width: 250, height: 50)
//                        .padding(.horizontal)
//                        .background(Color.gray.opacity(0.3).cornerRadius(10))
//                        .padding(.horizontal)
//                }
//                
//                Section("Welches Layout soll kopiert werden?") {
//                    Picker("Test", selection: $textFieldText) {
//                        ForEach(cardColor) { liste in
//                            Text(liste.listName)
//                        }
//                    }
//                    .pickerStyle(.inline)
//                }
//                
//                ColorPaletteView2(selectedColor: $selectedColor)
//            }
//            
//            .toolbar {
//                ToolbarItem(placement: .topBarTrailing) {
//                    Button("Hinzufügen") {
//                        if !textFieldText.isEmpty && selectedColor != nil {
//                            let newInfo = ListInfo(listName: textFieldText, backgroundColor: selectedColor!, accentColor: Theme.accentColor(for: selectedColor!))
//                            cardColor.append(newInfo)
//                            textFieldText = ""
//                            isPresented = false
//                            accentColor = Theme.accentColor(for: selectedColor!)
//                        }
//                    }
//                }
//            }
//            /*Spacer()
//            
//            Button(action: {
//                if !textFieldText.isEmpty && selectedColor != nil {
//                    let newInfo = ListInfo(listName: textFieldText, backgroundColor: selectedColor!, accentColor: Theme.accentColor(for: selectedColor!))
//                    cardColor.append(newInfo)
//                    textFieldText = ""
//                    isPresented = false
//                    accentColor = Theme.accentColor(for: selectedColor!)
//                }
//            }, label: {
//                Text("Liste hinzufügen")
//                    .foregroundStyle(.white)
//                    .font(.title2)
//                    .bold()
//                    .frame(height: 50)
//                    .frame(maxWidth: .infinity)
//                    .background(Color.blue.cornerRadius(25))
//            })
//            .padding()*/
//            .navigationTitle("Neue Liste anlegen")
//            .navigationBarTitleDisplayMode(.inline)
//        }
//    }
//}

#Preview {
    MainListView()
}
