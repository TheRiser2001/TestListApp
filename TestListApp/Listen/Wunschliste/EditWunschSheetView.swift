//
//  EditWunschSheet.swift
//  TestListApp
//
//  Created by Michael Ilic on 10.04.24.
//

import SwiftUI

struct EditWunschSheetView: View {
    
    @Namespace private var ns
    
    @State private var testToggle = false
    
    @Binding var wunsch: WunschModel
    
    var body: some View {
        Form {
            Section("Artikeldetail") {
                TextField("", text: $wunsch.name)
            }
            
            Section("Priorität") {
                PriorityPicker(prioPicker: $wunsch.priority)
            }
            
            Section("Zeitraum") {
                DatePicker("Wunschtermin", selection: $wunsch.date, displayedComponents: .date)
            }
            
            Section("Ersparnis") {
                HStack {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("€")
                            TextField("Ersparnis", value: $wunsch.gespart, formatter: NumberFormatter())
                        }
                        HStack {
                            if testToggle {
                                Text("Gesamtkosten: ")
                                TextField("Test", value: $wunsch.kosten, formatter: NumberFormatter())
                            } else {
                                Text("Gesamtkosten: \(String(format: "%.0f", wunsch.kosten))€")
                            }
                            Spacer()
                            Button("Bearbeiten") {
                                testToggle.toggle()
                            }
                        }
                        .font(.footnote)
                    }
                    Spacer()
                    
                    Gauge(value: wunsch.gaugeProzent) {
                        Text("\(String(format: "%.0f", wunsch.gaugeProzent * 100))%")
                    }
                    .gaugeStyle(.accessoryCircularCapacity)
                    .tint(wunsch.priority.color)
                    
                    //MARK: Muss dann nach wunsch.gaugeProzent angepasst werden
//                    .gesture(
//                        DragGesture()
//                            .onEnded { gesture in
//                                let swipeWidth = 10 // Anpassen der Wischbreite nach Bedarf
//                                if gesture.translation.width > CGFloat(swipeWidth) {
//                                    wunsch.gaugeRing += 0.05
//                                    if wunsch.gaugeRing > 1 {
//                                        wunsch.gaugeRing = 1
//                                    }
//                                    
//                                    wunsch.gaugeProzent += 5
//                                    if wunsch.gaugeProzent > 100 {
//                                        wunsch.gaugeProzent = 100
//                                    }
//                                } else if gesture.translation.width < -CGFloat(swipeWidth) {
//                                    wunsch.gaugeRing -= 0.05
//                                    if wunsch.gaugeRing < 0 {
//                                        wunsch.gaugeRing = 0
//                                    }
//                                    
//                                    wunsch.gaugeProzent -= 5
//                                    if wunsch.gaugeProzent < 0 {
//                                        wunsch.gaugeProzent = 0
//                                    }
//                                }
//                            }
//                    )
                }
            }
            
            Section("Notizen") {
                TextEditor(text: $wunsch.notizen)
                    .frame(height: 160)
            }
            
            Button("Wunsch erfüllt") {
                
            }
            
            Button("Artikel löschen") {
                
            }
            .foregroundStyle(.red)
            .frame(height: 30)
        }
        .navigationTitle("Detailansicht")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct KostenView: View {
    var body: some View {
        /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Hello, world!@*/Text("Hello, world!")/*@END_MENU_TOKEN@*/
    }
}

#Preview {
    EditWunschSheetView(wunsch: .constant(WunschModel(name: "iPad Pro 11''", priority: .dringend, date: Date(), kosten: 1400)))
}
