//
//  EditWunschSheet.swift
//  TestListApp
//
//  Created by Michael Ilic on 10.04.24.
//

import SwiftUI

struct EditWunschSheetView: View {
    
    @Namespace private var ns
    
    @State private var notizen: String = ""
    
    @Binding var prioPicker: Priority
    @Binding var gaugeProzent: Double
    @Binding var gaugeRing: Double
    @Binding var wunschDatum: Date
    @Binding var nameTextField: String
    @Binding var kosten: String
    
    let wunsch: WunschModel
    
    var body: some View {
        Form {
            Section("Artikeldetail") {
                TextField("", text: $nameTextField)
            }
            
            Section("Priorität") {
                Picker("", selection: $prioPicker) {
                    ForEach(Priority.allCases, id: \.self) { priority in
                        Text(priority.asString)
                    }
                }
                .pickerStyle(.segmented)
                .background {
                    
                    HStack(spacing: 0) {
                        ForEach(Priority.allCases, id: \.self) { priority in
                            Color.clear
                                .matchedGeometryEffect(id: priority, in: ns, isSource: true)
                        }
                    }
                }
                .overlay {
                    ZStack {
                        prioPicker.color
                        Text(prioPicker.asString)
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                    }
                    .matchedGeometryEffect(id: prioPicker, in: ns, isSource: false)
                    .clipShape(RoundedRectangle(cornerRadius: 7))
                    .animation(.spring(duration: 0.28), value: prioPicker)
                }
            }
            
            Section("Zeitraum") {
                DatePicker("Wunschtermin", selection: $wunschDatum, displayedComponents: .date)
            }
            
            Section("Kosten") {
                HStack {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("€")
                            TextField("", text: $kosten)
                        }
                        Text("Bereits angespart: \(String(format: "%.0f", wunsch.kostenInsgesamt))€")
                            .font(.footnote)
                    }
                    Spacer()
                    
                    Gauge(value: gaugeRing) {
                        Text("\(String(format: "%.0f", gaugeProzent))%")
                    }
                    .gaugeStyle(.accessoryCircularCapacity)
                    .tint(prioPicker.color)
                    .gesture(
                        DragGesture()
                            .onEnded { gesture in
                                let swipeWidth = 10 // Anpassen der Wischbreite nach Bedarf
                                if gesture.translation.width > CGFloat(swipeWidth) {
                                    gaugeRing += 0.05
                                    if gaugeRing > 1 {
                                        gaugeRing = 1
                                    }
                                    
                                    gaugeProzent += 5
                                    if gaugeProzent > 100 {
                                        gaugeProzent = 100
                                    }
                                } else if gesture.translation.width < -CGFloat(swipeWidth) {
                                    gaugeRing -= 0.05
                                    if gaugeRing < 0 {
                                        gaugeRing = 0
                                    }
                                    
                                    gaugeProzent -= 5
                                    if gaugeProzent < 0 {
                                        gaugeProzent = 0
                                    }
                                }
                            }
                    )
                }
            }
            
            Section("Notizen") {
                TextEditor(text: $notizen)
                    .frame(height: 160)
            }
            
            Button("Artikel löschen") {
                
            }
            .foregroundStyle(.red)
            .frame(maxWidth: .infinity)
            .frame(height: 30)
        }
        .navigationTitle("Detailansicht")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    @Namespace var namespace
    return EditWunschSheetView(prioPicker: .constant(.dringend), gaugeProzent: .constant(25.0), gaugeRing: .constant(0.25), wunschDatum: .constant(.now), nameTextField: .constant("iPad Pro 11''"), kosten: .constant("200"), wunsch: WunschModel(name: "", priority: .dringend, date: .now, kosten: "", gaugeProzent: 0.50, gaugeRing: 0.50))
}
