//
//  KalenderView.swift
//  TestListApp
//
//  Created by Michael Ilic on 26.03.24.
//

import SwiftUI

class Ereignis: Identifiable {
    let id = UUID()
    let name: String
//    let uhrzeit: Calendar.Component
    
    init(name: String /*, uhrzeit: Calendar.Component*/) {
        self.name = name
//        self.uhrzeit = uhrzeit
    }
}

struct KalenderView: View {
    
    @State private var date = Date()
    @State private var showSheet: Bool = false
    @State private var ereignisse: [Ereignis] = [
        Ereignis(name: "Ian fetzen"),
        Ereignis(name: "Ian ins Krankenhaus fahren")
    ]
    
    let listInfo: ListInfo
    
    var body: some View {
        NavigationStack {
            VStack {
                DatePicker("", selection: $date, displayedComponents: .date)
                    .datePickerStyle(.graphical)
                Divider()
                Spacer()
                
                List {
                    ForEach(ereignisse) { ereignis in
                        HStack {
                            Text("20:45")
                            Text(ereignis.name)
                        }
                    }
                }
                .listStyle(.plain)
                
                if ereignisse.isEmpty {
                    Text("Keine Einträge für diesen Tag vorhanden")
                }
                
                Spacer()
            }
        }
        .navigationTitle("Alle Jahre wieder")
        .toolbarBackground(listInfo.backgroundColor.opacity(0.6), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu("Filter") {
                    Button {
                        
                    } label: {
                        HStack {
                            Image(systemName: "checkmark.square")
                            Text("Geburtstag")
                        }
                    }
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showSheet.toggle()
                } label: {
                    Image(systemName: "plus.circle")
                }
            }
        }
        .sheet(isPresented: $showSheet) {
            AddView(date: $date)
        }
    }
}

struct AddView: View {
    
    @State private var textFieldTitel: String = ""
    @State private var textFieldOrt: String = ""
    @State private var kategorieName: String = "Geschenk"
    @State private var wiederhName: String = "Täglich"
    @State private var textFieldText: String = ""
    
    @Binding var date: Date
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("", text: $textFieldOrt, prompt: Text("Ort des Ereignisses"))
                    TextField("", text: $textFieldTitel, prompt: Text("Titel des Ereignisses"))
                }
                
                Section {
                    HStack {
                        Text("Für was?")
                        Spacer()
                        Menu(kategorieName) {
                            Button("Geschenk") {
                                kategorieName = "Geschenk"
                            }
                            
                            Button("Arbeit") {
                                kategorieName = "Arbeit"
                            }
                            
                            Button {
                                kategorieName = "Privat"
                            } label: {
                                HStack {
                                    Text("Privat")
                                    /*Image(systemName: "circle.fill")
                                     .symbolRenderingMode(.multicolor)
                                     .tint(.red)*/
                                }
                            }
                            
                        }
                    }
                    DatePicker("Datum", selection: $date)
                    HStack {
                        Text("Wie oft wiederholt es sich?")
                        Spacer()
                        Menu(wiederhName) {
                            
                            Button("Täglich") {
                                wiederhName = "Täglich"
                            }
                            
                            Button("Wöchentlich") {
                                wiederhName = "Wöchentlich"
                            }
                            
                            Button("Monatlich") {
                                wiederhName = "Monatlich"
                            }
                            
                            Button("Jährlich") {
                                wiederhName = "Jährlich"
                            }
                        }
                    }
                }
                
                Section {
                    TextField("", text: $textFieldText, prompt: Text("Notizen"))
                        .frame(height: 100, alignment: .top)
                }
                
            }
            .navigationTitle("Neues Ereignis")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    KalenderView(listInfo: ListInfo(listName: "", backgroundColor: .blue, accentColor: .blue))
}

#Preview {
    AddView(date: .constant(.now))
}
