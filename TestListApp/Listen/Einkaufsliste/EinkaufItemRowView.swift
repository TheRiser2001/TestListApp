////
////  EinkaufItemRowView.swift
////  TestListApp
////
////  Created by Michael Ilic on 08.02.25.
////
//
//import SwiftUI
//
//struct EinkaufItemRowView: View {
//    
//    @State private var isDone: Bool = false
//    @State private var anzahlObjekt: Int = 3
//    @State private var showSheet: Bool = false
//    @State private var showCategorySheet: Bool = false
//    
////    @Binding var listenName: String
//    let testName = "Neuer Artikel"
//    
//    @Binding var artikeln: Artikel
//    
//    @State private var kategorienTest = [
//        KategorienTest(name: "Hofer", color: .poppy),
//        KategorienTest(name: "Billa", color: .yellow),
//        KategorienTest(name: "Spar", color: .green),
//        KategorienTest(name: "Lidl", color: .buttercup),
//        KategorienTest(name: "Bipa", color: .bubblegum)
//    ]
//    
//    var body: some View {
//        HStack {
//            
//            Circle()
//                .fill(.yellow)
//                .frame(width: 15)
//                .onTapGesture {
//                    showCategorySheet = true
//                }
//            
////            if listenName.isEmpty {
////                TextField(testName, text: $listenName)
////                    .strikethrough(isDone ? true : false)
////                    .foregroundStyle(Color.gray.opacity(0.5))
////            } else {
////                TextField(listenName, text: $listenName)
////                    .strikethrough(isDone ? true : false)
////                    .foregroundStyle(isDone ? .gray : .primary)
////            }
//            Text(artikeln.artikel)
//                .strikethrough(isDone ? true : false)
//                .foregroundStyle(isDone ? .gray : .primary)
//            
//            Spacer()
//            
//            Button(action: { showSheet = true } ) {
//                Text("\(anzahlObjekt)x")
//            }
//            
//            Image(systemName: isDone ? "checkmark.circle.fill" : "checkmark.circle")
//                .foregroundStyle(isDone ? .green : .primary)
//                .onTapGesture {
//                    isDone.toggle()
//                }
//        }
////        .sheet(isPresented: $showSheet) {
////            ItemAnzahl(anzahlObjekt: $anzahlObjekt, listenName: listenName)
////                .presentationDetents([.fraction(0.3)])
////            }
//        .sheet(isPresented: $showCategorySheet) {
//            ScrollView(.horizontal) {
//                HStack {
//                    ForEach(Supermarkt.allCases, id: \.self) { supermarkt in
//                        Text("\(supermarkt)".capitalized)
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
//            .presentationDetents([.fraction(0.2)])
//        }
//    }
//}
//
//#Preview {
//    EinkaufItemRowView(artikeln: .constant(Artikel(supermarkt: .billa, artikel: "Banane")))
//}
