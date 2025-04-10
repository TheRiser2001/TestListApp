////
////  EinkaufslisteDetailView.swift
////  TestListApp
////
////  Created by Michael Ilic on 08.02.25.
////
//
//import SwiftUI
//import SwiftData
//
//struct KategorienTest: Identifiable {
//    let id = UUID()
//    let name: String
//    let color: Color
//}
//
//enum Supermarkt: CaseIterable {
//    case billa
//    case spar
//    case hofer
//    case lidl
//    case bipa
//    
//    var color: Color {
//        switch self {
//        case .billa: return .yellow
//        case .spar: return .green
//        case .hofer: return .poppy
//        case .lidl: return .buttercup
//        case .bipa: return .bubblegum
//        }
//    }
//}
//
//class Artikel {
//    let supermarkt: Supermarkt
//    let artikel: String
//    
//    init(supermarkt: Supermarkt, artikel: String) {
//        self.supermarkt = supermarkt
//        self.artikel = artikel
//    }
//}
//
//struct EinkaufslisteDetailView: View {
//    
//    @Environment(\.modelContext) var context
//    @State private var artikeln: [Artikel] = [
//        Artikel(supermarkt: .billa, artikel: "Apfel"),
//        Artikel(supermarkt: .billa, artikel: "Birne"),
//        Artikel(supermarkt: .spar, artikel: "Klopapier")
//    ]
//    
//    let listInfo: ListInfo
//    
//    var body: some View {
//        VStack {
//            ScrollView(.horizontal) {
//                HStack {
//                    ForEach(Supermarkt.allCases, id: \.self) { supermarkt in
//                        Text("\(supermarkt)".capitalized)
//                            .bold()
//                            .padding()
//                            .background {
//                                RoundedRectangle(cornerRadius: 25)
//                                    .fill(supermarkt.color.opacity(0.5))
//                            }
//                            .padding(.leading)
//                            .padding(.top)
//                    }
//                }
//            }
//            .scrollIndicators(.hidden)
//            
//            List {
//                DisclosureGroup {
//                    ForEach(artikeln.indices, id:\.self) { index in
//                        EinkaufItemRowView(artikeln: $artikeln[index])
//                    }
////                    .onDelete { indexSet in
////                        for index in indexSet {
////                            listenArray.arrays.remove(at: index)
////                            testAnzahl -= 1
////                        }
////                    }
//                    
//                    Button {
////                        let newItem = EinkaufModel(name: "Test", anzahl: 3)
//                        withAnimation {
////                            listenArray.arrays.append(newItem.name)
////                            listenArray.objectWillChange.send()
//                        }
//                    } label: {
//                        Label("Add", systemImage: "plus")
//                    }
//                } label: {
//                    HStack {
//                        Text("Getränke")
//                            .fontWeight(.semibold)
//                    }
//                }
//            }
//            .listStyle(.insetGrouped)
//        }
//        .background(Color(.systemGray6))
//        
//        //MARK: Das hier ist ein weiterer Test
//        .navigationBarItems(trailing: Button {
//            //self.disclosureGroups.append(false)
//        } label: {
//            Image(systemName: "plus.circle")
//        })
//        //MARK: Hier endet der Test
//        
//        
//        .toolbarBackground(listInfo.backgroundColor, for: .navigationBar)
//        .toolbarBackground(.visible, for: .navigationBar)
//        .navigationTitle("Einkäufe")
//    }
//}
//
////#Preview {
////    EinkaufslisteDetailView(listInfo: ListInfo(listName: "Listenname", systemName: "cart", backgroundColor: .tuerkis, accentColor: .black))
////}
