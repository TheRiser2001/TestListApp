//
//  AddWunschSheetView.swift
//  TestListApp
//
//  Created by Michael Ilic on 05.04.24.
//

import SwiftUI

struct AddWunschSheetView: View {
    
    
    @State private var titelTextField: String = ""
    @State private var kostenTextField: String = ""
    @State private var notizen: String = ""
    
    @State private var kosten: Double = 100
    @State private var gespart: Double = 0
    private var gaugeProzent: Double { (gespart/kosten) }
    
    @State private var alert: Bool = false
    @State private var toggleGespart: Bool = false
    
    @State private var prioPicker: Priority = .niedrig
    @State private var wunschDatum: Date = .now
    
    @Binding var wuensche: [WunschModel]
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Artikeldetails") {
                    TextField("", text: $titelTextField, prompt: Text("Name des Artikels"))
                }
                
                Section("Priorität") {
                    PriorityPicker(prioPicker: $prioPicker)
                }
                
                Section("Zeitraum") {
                    DatePicker("Wunschtermin", selection: $wunschDatum, displayedComponents: .date)
                }
                
                Section("Preis") {
                    PreisView(kosten: $kosten, gespart: $gespart, toggleGespart: $toggleGespart)
                }
                //MARK: Hier werde ich mal was anderes probieren
//                Section("Kosten") {
//                    HStack {
//                        VStack(alignment: .leading) {
//                            HStack {
//                                Text("€")
//                                TextField("", text: $kostenTextField, prompt: Text("0"))
//                                    .keyboardType(.numberPad)
//                            }
//                            Text("1234€ gesamt")
//                                .font(.footnote)
//                        }
//                        Spacer()
//                        
//                        Gauge(value: gaugeProzent) {
//                            Text("\(String(format: "%.0f", gaugeProzent * 100))%")
//                        }
//                        .gaugeStyle(.accessoryCircularCapacity)
//                        .tint(prioPicker.color)
////                        .gesture(
////                            DragGesture()
////                                .onEnded { gesture in
////                                    let swipeWidth = 10 // Anpassen der Wischbreite nach Bedarf
////                                    if gesture.translation.width > CGFloat(swipeWidth) {
////                                        gaugeRing += 0.05
////                                        if gaugeRing > 1 {
////                                            gaugeRing = 1
////                                        }
////
////                                        gaugeProzent += 5
////                                        if gaugeProzent > 100 {
////                                            gaugeProzent = 100
////                                        }
////                                    } else if gesture.translation.width < -CGFloat(swipeWidth) {
////                                        gaugeRing -= 0.05
////                                        if gaugeRing < 0 {
////                                            gaugeRing = 0
////                                        }
////
////                                        gaugeProzent -= 5
////                                        if gaugeProzent < 0 {
////                                            gaugeProzent = 0
////                                        }
////                                    }
////                                }
////                        )
//                    }
//                }
                
                Section("Notizen") {
                    TextEditor(text: $notizen)
                        .frame(height: 160)
                }
                
            }
            .navigationTitle("Neuen Artikel hinzufügen")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        addWunsch()
                    }
                }
            }
            .alert("Achtung!", isPresented: $alert) {  } message: {
                Text("Du musst einen Namen und einen Preis eingeben.")
            }
        }
    }
    
    func addWunsch() {
        guard titelTextField != "" else {
            alert.toggle()
            return
        }
        let newWunsch = WunschModel(name: titelTextField, priority: prioPicker, date: .now, kosten: kosten, gespart: gespart)
        wuensche.append(newWunsch)
        dismiss()
    }
}

struct GaugeSheet: View {
    
    @Binding var amount: Double
    @Binding var gaugeAmount: Double
    let prioPicker: Priority
    
    var body: some View {
        VStack(alignment: .center) {
            Grid {
                ForEach(0..<2) { _ in
                    GridRow {
                        HStack(alignment: .bottom) {
                            ForEach(0..<5) { _ in
                                Gauge(value: amount) {
                                    Text("\(String(format: "%.0f", gaugeAmount))%")
                                }
                            }
                        }
                        .gaugeStyle(.accessoryCircularCapacity)
                        .tint(prioPicker.color)
                    }
                }
            }
        }
    }
}

struct PreisView: View {
    
    @Binding var kosten: Double
    @Binding var gespart: Double
    @Binding var toggleGespart: Bool
    
    var body: some View {
        VStack {
            HStack {
                Text("Kosten")
                Spacer()
                ZStack(alignment: .trailing) {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(Color.secondary.opacity(0.1))
                        .frame(width: 80)
                    TextField("Test", value: $kosten, formatter: NumberFormatter())
                        .multilineTextAlignment(.trailing)
                        .padding(.trailing)
                }
                Text("€")
            }
            Toggle("Bereits was gespart?", isOn: $toggleGespart)
            if toggleGespart {
                HStack {
                    Text("Wieviel hast du bereits gespart?")
                    ZStack(alignment: .trailing) {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(Color.secondary.opacity(0.1))
                            .frame(width: 80)
                        TextField("Test", value: $gespart, formatter: NumberFormatter())
                            .multilineTextAlignment(.trailing)
                            .padding(.trailing)
                    }
                    Text("€")
                }
            }
        }
    }
}

#Preview {
    AddWunschSheetView(wuensche: .constant([WunschModel(name: "Test", priority: .mittel, date: .now, kosten: 0.0)]))
 }
