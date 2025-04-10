//
//  Einkaufsliste.swift
//  TestListApp
//
//  Created by Michael Ilic on 02.02.24.
//
//
//import SwiftUI
//import SwiftData
//
//struct Einkaufsliste: View {
//    
//    @Environment(\.modelContext) var context
//    
//    @State var liste: [ListenArray] = [
//        ListenArray(kategorie: "Obst", arrays: ["🍎 Apfel", "🍐 Birne"], gruppe: .produktgruppe),
//        ListenArray(kategorie: "Fleisch", arrays: ["🍗 Hühnerfleisch", "🥩 Schweinefleisch"], gruppe: .produktgruppe),
//        ListenArray(kategorie: "Hofer", arrays: ["⚡️ Flying Power"], gruppe: .supermarkt)
//    ]
//    
//    @State var showSheet: Bool = false
//    @State private var testAnzahl: Int = 0
//    @Query var items2: [EinkaufModel]
//    @Binding var accentColor: Color
//    @Binding var backgroundColor: Color
//    let navTitle: String
//    let listInfo: ListInfo
//    
//    var body: some View {
//        NavigationStack {
//            ScrollView {
//                Section {
//                    HStack {
//                        ForEach(liste.indices, id: \.self) { index in
//                            let item = liste[index]
//                            if item.gruppe == .produktgruppe {
//                                NavigationLink {
//                                    EinkaufslisteDetailView(listenArray: liste[index], kategorieName: $liste[index].kategorie, testAnzahl: $testAnzahl)
//                                    Divider()
//                                } label: {
//                                    let anzahl = liste[index].arrays.count
//                                    ZStack {
//                                        RoundedRectangle(cornerRadius: 15)
//                                            .stroke()
//                                        
//                                        VStack(alignment: .leading) {
//                                            HStack {
//                                                Image(systemName: "apple.logo")
//                                                    .padding(.horizontal)
//                                                
//                                                Spacer()
//                                                
//                                                Text("\(testAnzahl)")
//                                                    .font(.caption2)
//                                                    .opacity(0)
//                                                
//                                                ZStack {
//                                                    RoundedRectangle(cornerRadius: 10)
//                                                        .stroke()
//                                                        .frame(width: 40, height: 40)
//                                                    Text("\(anzahl)")
//                                                }
//                                                .padding()
//                                            }
//                                            
//                                            Text(liste[index].kategorie)
//                                                .padding()
//                                        }
//                                        .accentColor(listInfo.accentColor)
//                                        .font(.title2)
//                                        .fontWeight(.bold)
//                                        .frame(maxWidth: .infinity)
//                                        .background(listInfo.backgroundColor)
//                                        .cornerRadius(15)
//                                    }
//                                }
//                                .onAppear {
//                                    testAnzahl = liste[index].arrays.count
//                                }
//                            }
//                        }
//                    }
//                } header: {
//                    Text("Produktgruppe")
//                }
//                
//                Section {
//                    ForEach(liste.indices, id: \.self) { index in
//                        let item = liste[index]
//                        if item.gruppe == .supermarkt {
//                            NavigationLink {
//                                EinkaufslisteDetailView(listenArray: liste[index], kategorieName: $liste[index].kategorie, testAnzahl: $testAnzahl)
//                                Divider()
//                            } label: {
//                                let anzahl = liste[index].arrays.count
//                                ZStack {
//                                    RoundedRectangle(cornerRadius: 15)
//                                        .stroke()
//                                    
//                                    HStack {
//                                        Image(systemName: "apple.logo")
//                                            .padding(.horizontal)
//                                        
//                                        Spacer()
//                                        
//                                        Text(liste[index].kategorie)
//                                        
//                                        Spacer()
//                                        
//                                        Text("\(testAnzahl)")
//                                            .opacity(0)
//                                        
//                                        ZStack {
//                                            RoundedRectangle(cornerRadius: 10)
//                                                .stroke()
//                                                .frame(width: 40, height: 40)
//                                            Text("\(anzahl)")
//                                        }
//                                        
//                                        Image(systemName: "arrow.right")
//                                            .padding()
//                                    }
//                                }
//                                .accentColor(Color.black)
//                                .font(.title2)
//                                .fontWeight(.bold)
//                                .frame(width: 350, height: 60)
//                                .background(listInfo.backgroundColor.opacity(1))
//                                .cornerRadius(15)
//                            }
//                            .onAppear {
//                                testAnzahl = liste[index].arrays.count
//                            }
//                        }
//                    }
//                    
//                    ForEach(liste.indices, id: \.self) { index in
//                        let item = liste[index]
//                        if item.gruppe == .supermarkt {
//                            NavigationLink {
//                                EinkaufslisteDetailView(listenArray: liste[index], kategorieName: $liste[index].kategorie, testAnzahl: $testAnzahl)
//                                Divider()
//                            } label: {
//                                let anzahl = liste[index].arrays.count
//                                ZStack {
//                                    RoundedRectangle(cornerRadius: 15)
//                                        .stroke()
//                                    
//                                    HStack {
//                                        Image(systemName: "apple.logo")
//                                            .padding(.horizontal)
//                                        
//                                        Spacer()
//                                        
//                                        Text(liste[index].kategorie)
//                                        
//                                        Spacer()
//                                        
//                                        Text("\(testAnzahl)")
//                                            .opacity(0)
//                                        
//                                        ZStack {
//                                            RoundedRectangle(cornerRadius: 10)
//                                                .stroke()
//                                                .frame(width: 40, height: 40)
//                                            Text("\(anzahl)")
//                                        }
//                                        
//                                        Image(systemName: "arrow.right")
//                                            .padding()
//                                    }
//                                }
//                                .accentColor(Color.white)
//                                .font(.title2)
//                                .fontWeight(.bold)
//                                .frame(width: 350, height: 60)
//                                .background(listInfo.backgroundColor.opacity(0.8))
//                                .cornerRadius(15)
//                            }
//                            .onAppear {
//                                testAnzahl = liste[index].arrays.count
//                            }
//                        }
//                    }
//                } header: {
//                    Text("Supermarkt")
//                        .padding(.top)
//                }
//            }
//        }
//        .navigationBarItems(
//            trailing: Button { showSheet.toggle() } label: {
//                Image(systemName: "plus.circle")
//            }
//            .sheet(isPresented: $showSheet) {
//                AddKategorie(listenArray: $liste, showSheet: $showSheet)
//                    .presentationDetents([.fraction(0.6)])
//            }
//        )
//        .toolbarBackground(listInfo.backgroundColor, for: .navigationBar)
//        .toolbarBackground(.visible, for: .navigationBar)
//        .navigationTitle(navTitle)
//    }
//}
//
//struct ItemAnzahl: View {
//    
//    @Binding var anzahlObjekt: Int
//    
//    let listenName: String
//    
//    var body: some View {
//        NavigationStack {
//            Picker("", selection: $anzahlObjekt) {
//                ForEach(0..<101) { zahl in
//                    Text("\(zahl)")
//                        .foregroundStyle(.primary)
//                }
//            }
//            .pickerStyle(.inline)
//            .navigationTitle("Anzahl für \(listenName)")
//            .navigationBarTitleDisplayMode(.inline)
//        }
//    }
//}
//
//struct AddKategorie: View {
//    
//    @Environment(\.modelContext) var context
//    @State private var textFieldText: String = ""
//    @State private var color: Color = .red
//    @State private var gruppe: Gruppe = .produktgruppe
//    @Binding var listenArray: [ListenArray]
//    @Binding var showSheet: Bool
//    
//    var body: some View {
//        NavigationStack {
//            Spacer()
//            HStack {
//                VStack {
//                    Section("Name") {
//                        
//                        TextField("Füge eine neue Produktgruppe oder Supermarkt hinzu", text: $textFieldText)
//                            .frame(width: 250, height: 50)
//                            .padding(.horizontal)
//                            .background(Color.gray.opacity(0.3).cornerRadius(10))
//                            .padding(.horizontal)
//                    }
//                    .padding(.top, 5)
//                    
//                    Picker("Gruppe:", selection: $gruppe) {
//                        ForEach(Gruppe.allCases, id: \.self) { gruppe in
//                            Text(gruppe.gruppenName())
//                        }
//                    }
//                    .pickerStyle(.inline)
//                }
//            }
//            .padding(.bottom, 20)
//            
//            Spacer()
//            
//            Button(action: {
//                let newKategorie = ListenArray(kategorie: textFieldText, arrays: [], gruppe: gruppe)
//                listenArray.append(newKategorie)
//                showSheet = false
//            }, label: {
//                AddItemButton(title: "Kategorie hinzufügen")
//            })
//            .padding()
//            .navigationTitle("Neue Kategorie")
//        }
//    }
//}
//
//#Preview {
//    Einkaufsliste(accentColor: .constant(.red), backgroundColor: .constant(.green), navTitle: "Test", listInfo: ListInfo(listName: "Listenname", backgroundColor: .tuerkis, accentColor: .black))
//}
