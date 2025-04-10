//
//  EinkaufAddView.swift
//  TestListApp
//
//  Created by Michael Ilic on 02.02.24.
//
//
//import SwiftUI
//import SwiftData
//
//struct EinkaufAddView: View {
//    
//    @Environment (\.modelContext) var context
//    @Environment (\.dismiss) var dismiss
//    
//    @State private var artikelTextField: String = ""
//    @State private var anzahlTextField: String = ""
//    
//    @State private var ausgewaehlt: String = "Obst"
//    let kategorien = ["Obst", "Fleisch", "Getränke", "Milchprodukte"]
//    
//    var body: some View {
//        NavigationStack {
//            
//            VStack {
//                HStack(alignment: .bottom) {
//                    VStack {
//                        Section("Produkt") {
//                            TextField("Hinzufügen...", text: $artikelTextField)
//                                .frame(width: 200, height: 50)
//                                .padding(.horizontal)
//                                .background(Color.gray.opacity(0.3).cornerRadius(10))
//                                .padding(.horizontal)
//                        }
//                    }
//                    
//                    VStack {
//                        Section("Anzahl") {
//                            TextField("0", text: $anzahlTextField)
//                                .keyboardType(.numberPad)
//                                .frame(height: 50)
//                                .frame(maxWidth: .infinity)
//                                .padding(.horizontal)
//                                .background(Color.gray.opacity(0.3).cornerRadius(10))
//                                .padding(.horizontal)
//                        }
//                    }
//                }
//                .padding(.bottom, 20)
//                
//                Section("Kategorie") {
//                    Picker("Kategorie", selection: $ausgewaehlt) {
//                        ForEach(kategorien, id: \.self) {
//                            Text($0)
//                        }
//                        
//                    }
//                    .pickerStyle(WheelPickerStyle())
//                    .frame(height: 150)
//                    .frame(maxWidth: .infinity)
//                    .padding(.horizontal)
//                    .background(Color.gray.opacity(0.3).cornerRadius(10))
//                    .padding(.horizontal)
//                }
//            }
//            .padding(.top, 30)
//            
//            Spacer()
//            
//            Button(action: {
//                addItem(context: context)
//                dismiss()
//            }, label: {
//                Text("Produkt hinzufügen")
//                    .foregroundStyle(.white)
//                    .font(.title2)
//                    .bold()
//                    .frame(height: 50)
//                    .frame(maxWidth: .infinity)
//                    .background(Color.blue.cornerRadius(25))
//            })
//            .padding()
//            
//            .navigationTitle("Artikel hinzufügen")
//        }
//    }
//    func addItem(context: ModelContext) {
//        let newItem = EinkaufModel(name: "Neuer Artikel", anzahl: 0)
//        context.insert(newItem)
//    }
//}
//
//#Preview {
//    EinkaufAddView()
//}
//
