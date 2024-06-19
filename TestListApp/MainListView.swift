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
    let backgroundColor: Color
    var accentColor: Color
}

enum Destination {
    case einkaufsliste
    case todoliste
    case wunschliste
    case geschenke
    case rezepte
    case anleitung
    case kalender
    case ausgabenrechner
}

struct MainListView: View {
    
    @State private var liste: [ListInfo] = [
        ListInfo(listName: "Einkaufsliste", backgroundColor: .hellgrün, accentColor: .black),
        ListInfo(listName: "Todoliste", backgroundColor: .silber, accentColor: .black),
        ListInfo(listName: "Wunschliste", backgroundColor: .tuerkis, accentColor: .black),
        ListInfo(listName: "Geschenke", backgroundColor: .pink, accentColor: .black),
        ListInfo(listName: "Rezepte", backgroundColor: .orange, accentColor: .black),
        ListInfo(listName: "Anleitungen", backgroundColor: .tan, accentColor: .black),
        ListInfo(listName: "Alle Jahre wieder", backgroundColor: .magenta, accentColor: .white),
        ListInfo(listName: "Ausgabenrechner", backgroundColor: .navy, accentColor: .white)
    ]
    @State private var newTitle: String = ""
    @State private var isPresented: Bool = false
    @Binding var backgroundColor: Color
    @State private var accentColor: Color = .black
    
    @State private var destination: Destination? = nil
    
    var body: some View {
        NavigationStack {
            List {
                
                ForEach(liste) { listInfo in
                    /*NavigationLink(destination: TestEinkaufsListe(navTitle: listInfo.listName, accentColor: $accentColor, backgroundColor: $backgroundColor, listInfo: listInfo)) {
                     CardView(listInfo: listInfo)
                     }*/
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
            }
            .navigationTitle("Listen")
            .navigationBarItems(
                leading: EditButton()/*,
                trailing:Button(action: {
                    isPresented = true
                }, label: {
                    Image(systemName: "plus.circle")
                })*/
            )
            .sheet(isPresented: $isPresented, content: {
                AddListe(cardColor: $liste, isPresented: $isPresented, accentColor: $accentColor, backgroundColor: $backgroundColor)
                    .presentationDetents([.fraction(0.8)])
            })
        }
        .listStyle(.plain)
        .onChange(of: backgroundColor) { _, newValue in
            liste.indices.forEach { index in
                liste[index].accentColor = Theme.accentColor(for: newValue)
            }
        }
    }
    
    func destination(for listInfo: ListInfo) -> Destination {
        switch listInfo.listName {
        case "Einkaufsliste": return .einkaufsliste
        case "Todoliste": return .todoliste
        case "Wunschliste": return .wunschliste
        case "Geschenke": return .geschenke
        case "Rezepte": return .rezepte
        case "Anleitungen": return .anleitung
        case "Alle Jahre wieder": return .kalender
        case "Ausgabenrechner": return .ausgabenrechner
        default: return .einkaufsliste
        }
    }
    
    func destinationView(for listInfo: ListInfo) -> some View {
        switch destination(for: listInfo) {
        case .einkaufsliste:
            return AnyView(Einkaufsliste(accentColor: $accentColor, backgroundColor: $backgroundColor, navTitle: listInfo.listName, listInfo: listInfo))
        case .todoliste:
            return AnyView(Todolist(navTitle: "Todoliste", listInfo: listInfo))
        case .wunschliste:
            return AnyView(WunschlisteView(listInfo: listInfo))
        case .geschenke:
            return AnyView(GeschenkeView(listInfo: listInfo))
        case .rezepte:
            return AnyView(RezepteView(listInfo: listInfo))
        case .anleitung:
            return AnyView(AnleitungenView(listInfo: listInfo))
        case .kalender:
            return AnyView(KalenderView(listInfo: listInfo))
        case .ausgabenrechner:
//            return AnyView(AusgabenView(listInfo: listInfo))
            return AnyView(TestView())
        }
    }
    
}


struct CardView: View {
    let listInfo: ListInfo
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(listInfo.backgroundColor)
            Text(listInfo.listName)
                .foregroundColor(listInfo.accentColor)
                .font(.headline)
                .padding(EdgeInsets(top: 25, leading: 10, bottom: 25, trailing: 5))
        }
    }
}


struct AddListe: View {
    
    @Environment(\.modelContext) var context
    @State private var textFieldText: String = ""
    @State private var selectedColor: Color?
    @Binding var cardColor: [ListInfo]
    @Binding var isPresented: Bool
    @Binding var accentColor: Color
    @Binding var backgroundColor: Color
    
    var body: some View {
        NavigationStack {
            VStack {
                Section("Liste") {
                    TextField("Name der Liste", text: $textFieldText)
                        .frame(width: 250, height: 50)
                        .padding(.horizontal)
                        .background(Color.gray.opacity(0.3).cornerRadius(10))
                        .padding(.horizontal)
                }
                
                Section("Welches Layout soll kopiert werden?") {
                    Picker("Test", selection: $textFieldText) {
                        ForEach(cardColor) { liste in
                            Text(liste.listName)
                        }
                    }
                    .pickerStyle(.inline)
                }
                
                ColorPaletteView2(selectedColor: $selectedColor)
            }
            
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Hinzufügen") {
                        if !textFieldText.isEmpty && selectedColor != nil {
                            let newInfo = ListInfo(listName: textFieldText, backgroundColor: selectedColor!, accentColor: Theme.accentColor(for: selectedColor!))
                            cardColor.append(newInfo)
                            textFieldText = ""
                            isPresented = false
                            accentColor = Theme.accentColor(for: selectedColor!)
                        }
                    }
                }
            }
            /*Spacer()
            
            Button(action: {
                if !textFieldText.isEmpty && selectedColor != nil {
                    let newInfo = ListInfo(listName: textFieldText, backgroundColor: selectedColor!, accentColor: Theme.accentColor(for: selectedColor!))
                    cardColor.append(newInfo)
                    textFieldText = ""
                    isPresented = false
                    accentColor = Theme.accentColor(for: selectedColor!)
                }
            }, label: {
                Text("Liste hinzufügen")
                    .foregroundStyle(.white)
                    .font(.title2)
                    .bold()
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue.cornerRadius(25))
            })
            .padding()*/
            .navigationTitle("Neue Liste anlegen")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    MainListView(backgroundColor: .constant(Color.red))
}
