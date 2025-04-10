//
//  KalenderView.swift
//  TestListApp
//
//  Created by Michael Ilic on 26.03.24.
//

import SwiftUI

enum KategorieCalendar {
    case privat
    case arbeit
    case geschenk
    
    var asString: String {
        "\(self)".capitalized
    }
}

enum WiederholungCalendar {
    case taeglich
    case woechentlich
    case monatlich
    case jaehrlich
    
    var asString: String {
        switch self {
        case .taeglich: return "täglich".capitalized
        case .woechentlich: return "wöchentlich".capitalized
        case .jaehrlich: return "jährlich".capitalized
        default: return "\(self)".capitalized
        }
    }
}

class Ereignis: Identifiable {
//    var date: Date
    var startZeit: Date
    var endZeit: Date
    var ereignis: String
    var kategorie: KategorieCalendar?
    var wiederholung: WiederholungCalendar?
    var color: Color
    
    init(startZeit: Date, endZeit: Date, ereignis: String, color: Color) {
        self.startZeit = startZeit
        self.endZeit = endZeit
        self.ereignis = ereignis
        self.color = color
    }
}

struct OldKalenderView: View {
    
    @State private var date = Date()
    @State private var showSheet: Bool = false
    @State private var ereignisse: [Ereignis] = [
        Ereignis(startZeit: .now, endZeit: .now, ereignis: "Test", color: .red),
        Ereignis(startZeit: .now, endZeit: .now, ereignis: "Tstet", color: .green)
    ]
    
//    @State private var selectedDay: Date?
//    @State private var ereignisProTag: [Ereignis] = [Ereignis(date: .now, ereignis: "Test Ereignis", color: .green)]
    
    let listInfo: ListInfo
    
    var body: some View {
        NavigationStack {
            VStack {
                DatePicker("", selection: $date, displayedComponents: .date)
                    .datePickerStyle(.graphical)
                Divider()
                
                VStack(alignment: .leading) {
                    Text("Ereignisse")
                        .padding(.horizontal)
                        .bold()
                    List(ereignisse) { ereignis in
                        HStack {
                            Circle()
                                .frame(width: 20)
                                .foregroundStyle(ereignis.color)
                            VStack(alignment: .leading) {
                                Text(ereignis.ereignis)
                                Text("\(ereignis.startZeit.formatted(date: .omitted, time: .shortened)) bis \(ereignis.endZeit.formatted(date: .omitted, time: .shortened))")
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .listStyle(.plain)
                }
                
//                if let selectedDay {
//                    EreignisView(day: selectedDay, ereignis: ereignisProTag)
//                }
                
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
    @State private var textFieldText: String = ""
    @State private var kategorieName: String = "Geschenk"
    @State private var wiederhName: String = "Täglich"
    
    @Binding var date: Date
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("", text: $textFieldTitel, prompt: Text("Titel des Ereignisses"))
                    TextField("", text: $textFieldOrt, prompt: Text("Ort des Ereignisses"))
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

//#Preview {
//    OldKalenderView(listInfo: ListInfo(listName: "Kalendae", systemName: "cart", backgroundColor: .yellow, accentColor: .black))
//}
//
//#Preview {
//    AddView(date: .constant(.now))
//}
