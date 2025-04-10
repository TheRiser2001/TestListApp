//
//  AddWunschSheetView.swift
//  TestListApp
//
//  Created by Michael Ilic on 05.04.24.
//

import SwiftUI

struct AddWishSheet: View {
    
    @State private var titleTextField: String = ""
    @State private var costTextField: String = ""
    @State private var notes: String = ""
    @State private var cost: Double = 100
    @State private var saved: Double = 0
    private var gaugePercent: Double { (saved/cost) }
    
    @State private var alert: Bool = false
    @State private var toggleSaved: Bool = false
    @State private var prioPicker: Priority = .niedrig
    @State private var wishDate: Date = .now
    
    @Binding var wishes: [WishModel]
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Artikeldetails") {
                    TextField("", text: $titleTextField, prompt: Text("Name des Artikels"))
                }
                
                Section("Priorität") {
                    PriorityPicker(prioPicker: $prioPicker)
                }
                
                Section("Zeitraum") {
                    DatePicker("Wunschtermin", selection: $wishDate, displayedComponents: .date)
                }
                
                Section("Preis") {
                    PriceView(cost: $cost, saved: $saved, toggleSaved: $toggleSaved)
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
                    TextEditor(text: $notes)
                        .frame(height: 160)
                }
                
            }
            .navigationTitle("Neuer Artikel")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        addWunsch()
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Button("Abbrechen") {
                        dismiss()
                    }
                }
            }
            .alert("Achtung!", isPresented: $alert) {  } message: {
                Text("Du musst einen Namen und einen Preis eingeben.")
            }
        }
    }
    
    func addWunsch() {
        guard titleTextField != "" else {
            alert.toggle()
            return
        }
        let newWish = WishModel(name: titleTextField, priority: prioPicker, date: .now, cost: cost, saved: saved)
        wishes.append(newWish)
        dismiss()
    }
}

//struct GaugeSheet: View {
//    
//    @Binding var amount: Double
//    @Binding var gaugeAmount: Double
//    let prioPicker: Priority
//    
//    var body: some View {
//        VStack(alignment: .center) {
//            Grid {
//                ForEach(0..<2) { _ in
//                    GridRow {
//                        HStack(alignment: .bottom) {
//                            ForEach(0..<5) { _ in
//                                Gauge(value: amount) {
//                                    Text("\(String(format: "%.0f", gaugeAmount))%")
//                                }
//                            }
//                        }
//                        .gaugeStyle(.accessoryCircularCapacity)
//                        .tint(prioPicker.color)
//                    }
//                }
//            }
//        }
//    }
//}

struct PriceView: View {
    
    @Binding var cost: Double
    @Binding var saved: Double
    @Binding var toggleSaved: Bool
    
    var body: some View {
        VStack {
            HStack {
                Text("Kosten")
                Spacer()
                ZStack(alignment: .trailing) {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(Color.secondary.opacity(0.1))
                        .frame(width: 80)
                    TextField("Test", value: $cost, formatter: NumberFormatter())
                        .multilineTextAlignment(.trailing)
                        .padding(.trailing)
                }
                Text("€")
            }
            Toggle("Bereits etwas angespart?", isOn: $toggleSaved)
            if toggleSaved {
                HStack {
                    Text("Gespart")
                    ZStack(alignment: .trailing) {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(Color.secondary.opacity(0.1))
                            .frame(width: 80)
                        TextField("Test", value: $saved, formatter: NumberFormatter())
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
    AddWishSheet(wishes: .constant([WishModel(name: "Test", priority: .mittel, date: .now, cost: 0.0)]))
 }
