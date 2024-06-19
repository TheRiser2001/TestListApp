//
//  OldMainListView.swift
//  TestListApp
//
//  Created by Michael Ilic on 26.02.24.
//
/*
import SwiftUI
//TODO: BIS HIER LÖSCHEN

struct OldMainListView: View {
    
    @State private var cardColor: [CardColor2] = []
    @State private var newTitle: String = ""
    @State private var isPresented: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(cardColor) { colorCard in
                    NavigationLink(destination: Einkaufsliste()) {
                        CardView2(listName: colorCard.listName, cardColor: colorCard.theme)
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(colorCard.theme.mainColor)
                            .padding(EdgeInsets(top: 2, leading: 10, bottom: 2, trailing: 10))
                    )
                }
                .onDelete { indices in
                    cardColor.remove(atOffsets: indices)
                }
            }
            .navigationTitle("Listen")
            .navigationBarItems(trailing:Button(action: {
                isPresented = true
            }, label: {
                Image(systemName: "plus")
            })
            )
            .sheet(isPresented: $isPresented) {
                VStack {
                    TextField("Titel eingeben", text: $newTitle)
                        .padding()
                    Button(action: addNewCardWithTitle) {
                        Text("Hinzufügen")
                    }
                    .padding()
                }
            }
        }
        .listStyle(.plain)
    }
    
    private func addNewCardWithTitle() {
        if !newTitle.isEmpty {
            let randomColor = CardColor2(theme: Theme2.allCases.randomElement()!, listName: newTitle)
            cardColor.append(randomColor)
            newTitle = ""
            isPresented = false
        }
    }
}


struct CardView2: View {
    let listName: String
    let cardColor: Theme2
    
    var body: some View {
        Text(listName)
            .foregroundColor(cardColor.accentColor)
            .font(.headline)
            .padding(EdgeInsets(top: 25, leading: 5, bottom: 25, trailing: 5))
    }
}


struct ListView2: View {
    
    let backgroundColor: Color
    let listName: String
    
    var body: some View {
        ZStack(alignment: .top) {
            Rectangle()
                .stroke()
                .frame(width: 150, height: 300)
                .background(Color(backgroundColor))
            Spacer()
            VStack {
                HStack {
                    Text(listName)
                        .foregroundStyle(Color.primary)
                        .font(.title3)
                }
                .padding(.top, 10)
                Spacer()
            }
        }
        .padding()
    }
}

struct CardColor2: Identifiable {
    let id = UUID()
    let theme: Theme2
    let listName: String
}

extension CardColor2 {
    static let sampleData: [CardColor2] = [
        CardColor2(theme: Theme2.allCases[0], listName: "Einkaufsliste"),
        CardColor2(theme: Theme2.allCases[1], listName: "Todo Liste"),
        CardColor2(theme: Theme2.allCases[2], listName: "Wunschliste")
    ]
}

enum Theme2: String, CaseIterable {
    case bubblegum, buttercup, indigo, lavender, magenta, navy, orange, oxblood, periwinkle, poppy, purple, seafoam, sky, tan, teal, yellow
    
    var accentColor: Color {
        switch self {
        case .bubblegum, .buttercup, .lavender, .orange, .periwinkle, .poppy, .seafoam, .sky, .tan, .teal, .yellow: return .black
        case .indigo, .magenta, .navy, .oxblood, .purple: return .white
        }
    }
    var mainColor: Color {
        Color(rawValue)
    }
}

#Preview {
    OldMainListView()
}
*/
