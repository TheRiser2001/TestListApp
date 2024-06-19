//
//  AddWunschSheetView.swift
//  TestListApp
//
//  Created by Michael Ilic on 05.04.24.
//

import SwiftUI

struct AddWunschSheetView: View {
    
    @Namespace private var ns
    
    @State private var titelTextField: String = ""
    @State private var kostenTextField: String = ""
    @State private var sliderValue = 1.0
    
    @Binding var gaugeRing: Double
    @Binding var gaugeProzent: Double
    
    var kostenInsgesamt: Double {
        if let kostenValue = Double(kostenTextField) {
            return (kostenValue / 100) * gaugeProzent
        } else {
            return 0
        }
    }
    
    @State private var selection: Period = Period.tag
    
    @State private var showSheet: Bool = false
    @State private var gaugeSheet: Bool = false
    
    @Binding var wunschDatum: Date
    @Binding var prioPicker: Priority
    
    @Binding var wuensche: [WunschModel]
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Artikeldetails") {
                    TextField("", text: $titelTextField, prompt: Text("Name des Artikels"))
                }
                
                Button("Test") {
                    gaugeSheet.toggle()
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
                    Picker("", selection: $selection) {
                        ForEach(Period.allCases, id: \.self) { period in
                            Text(period.asString)
                        }
                    }
                    .pickerStyle(.segmented)
                    .background {
                        HStack(spacing: 0) {
                            ForEach(Period.allCases, id: \.self) { period in
                                Color.clear
                                    .matchedGeometryEffect(id: period, in: ns, isSource: true)
                            }
                        }
                    }
                    .overlay {
                        ZStack {
                            prioPicker.color
                            Text(selection.asString)
                                .font(.footnote)
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                        }
                        .matchedGeometryEffect(id: selection, in: ns, isSource: false)
                        .clipShape(RoundedRectangle(cornerRadius: 7))
                        .animation(.spring(duration: 0.28), value: selection)
                    }
                    .onChange(of: selection) { _, _ in
                        sliderValue = 1
                    }
                    
                    VStack {
                        
                        Slider(
                            value: $sliderValue,
                            in: 1...Double(selection.maxSliderVal),
                            step: 1.0,
                            minimumValueLabel: Text("1"),
                            maximumValueLabel: Text("\(selection.maxSliderVal)"),
                            label: {}
                        )
                        .tint(prioPicker.color)
                        
                        HStack {
                            Spacer()
                            if selection == .tag {
                                VStack {
                                    HStack {
                                        Text("Tage bis zum Wunschtermin:")
                                        Text( String(format: "%.0f", sliderValue))
                                    }
                                    Text("\(berechneTag())")
                                }
                            } else if selection == .woche {
                                VStack {
                                    HStack {
                                        Text("Wochen bis zum Wunschtermin:")
                                        Text( String(format: "%.0f", sliderValue))
                                    }
                                    Text("\(berechneWoche())")
                                }
                            } else if selection == .monat {
                                VStack {
                                    HStack {
                                        Text("Monate bis zum Wunschtermin:")
                                        Text( String(format: "%.0f", sliderValue))
                                    }
                                    Text("\(berechneMonat())")
                                }
                            }
                            Spacer()
                        }
                    }
                }
                Section("Kosten") {
                    HStack {
                        VStack(alignment: .leading) {
                            HStack {
                                Text("€")
                                TextField("", text: $kostenTextField, prompt: Text("0"))
                                    .keyboardType(.numberPad)
                            }
                            Text("Soviel habe ich bereits: \(String(format: "%.2f", kostenInsgesamt))€")
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
            .sheet(isPresented: $gaugeSheet, content: {
                GaugeSheet(amount: $gaugeRing, gaugeAmount: $gaugeProzent, prioPicker: prioPicker)
                    .presentationDetents([.fraction(0.3)])
            })
            .alert("Achtung!", isPresented: $showSheet) {  } message: {
                Text("Du musst einen Namen und einen Preis eingeben.")
            }
        }
    }
    
    func addWunsch() {
        guard titelTextField != "" && kostenTextField != "" else {
            showSheet.toggle()
            return
        }
        let newWunsch = WunschModel(name: titelTextField, priority: prioPicker, date: .now, kosten: kostenTextField, gaugeProzent: gaugeProzent, gaugeRing: gaugeRing)
        wuensche.append(newWunsch)
        wuensche.sort { $0.priority > $1.priority }
        dismiss()
    }
    
    func berechneTag() -> String {
        let calendar = Calendar.current
        
        guard let futureDate = calendar.date(byAdding: .day, value: Int(sliderValue), to: wunschDatum) else {
            return ""
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy" // Das gewünschte Datumsformat hier einfügen
        
        let formattedDate = dateFormatter.string(from: futureDate)
        return formattedDate
    }
    
    func berechneWoche() -> String {
        let calendar = Calendar.current
        
        guard let futureDate = calendar.date(byAdding: .weekdayOrdinal, value: Int(sliderValue), to: wunschDatum) else {
            return ""
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy" // Das gewünschte Datumsformat hier einfügen
        
        let formattedDate = dateFormatter.string(from: futureDate)
        return formattedDate
    }
    
    func berechneMonat() -> String {
        let calendar = Calendar.current
        
        guard let futureDate = calendar.date(byAdding: .month, value: Int(sliderValue), to: wunschDatum) else {
            return ""
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy" // Das gewünschte Datumsformat hier einfügen
        
        let formattedDate = dateFormatter.string(from: futureDate)
        return formattedDate
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

/*#Preview {
 AddWunschSheetView()
 }*/
