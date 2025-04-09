//
//  EditWunschSheet.swift
//  TestListApp
//
//  Created by Michael Ilic on 10.04.24.
//

import SwiftUI

struct EditWunschSheetView: View {
    
    @Namespace private var ns
    
    @State private var testToggle: Bool = false
    @State private var showAlert: Bool = false
    @State private var bearbeiten: Bool = true
    
    @Binding var wunsch: WunschModel
    @Binding var wuensche: [WunschModel]
    
    var body: some View {
        if bearbeiten {
            BearbeitenOn(showAlert: $showAlert, bearbeiten: $bearbeiten, wunsch: $wunsch, wuensche: $wuensche)
        } else {
            BearbeitenOff(showAlert: $showAlert, bearbeiten: $bearbeiten, wunsch: $wunsch)
        }
    }
}

struct BearbeitenOff: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Binding var showAlert: Bool
    @Binding var bearbeiten: Bool
    @Binding var wunsch: WunschModel
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    var body: some View {
        Form {
            Section("Artikeldetails") {
                HStack {
                    Text("Name")
                    Spacer()
                    Text(wunsch.name)
                }
                
                HStack {
                    Text("Priorität")
                    Spacer()
                    Text("\(wunsch.priority.asString)")
                        .foregroundStyle(wunsch.priority.color)
                }
                
                HStack {
                    Text("Wunschtermin")
                    Spacer()
                    Text("\(wunsch.date, formatter: dateFormatter)")
                }
            }
            
            Section("Ersparnis") {
                HStack {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("€")
                            TextField("Ersparnis", value: $wunsch.gespart, formatter: NumberFormatter())
                                .onChange(of: wunsch.gespart) {
                                    if wunsch.gespart > wunsch.kosten {
                                        wunsch.gespart = wunsch.kosten
                                    }
                                    if wunsch.kosten <= -1 {
                                        wunsch.kosten = 0
                                    }
                                }
                        }
                        Text("Gesamtkosten: \(String(format: "%.0f", wunsch.kosten))€")
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
            
            if wunsch.abgeschlossen {
                Button("Wunsch zurückholen") {
                    showAlert.toggle()
                }
            } else {
                Button("Wunsch erfüllt") {
                    showAlert.toggle()
                }
            }
            
//            Button("Artikel löschen") {
//                alertDelete.toggle()
//            }
//            .foregroundStyle(.red)
//            .frame(height: 30)
        }
        .navigationTitle("Detailansicht")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Bearbeiten") {
                    withAnimation {
                        bearbeiten.toggle()
                    }
                }
            }
        }
        
        .alert(wunsch.abgeschlossen ? "Wunsch zurückholen" : "Wunsch erfüllt?", isPresented: $showAlert) {
            Button("Nein", role: .cancel) {
                if wunsch.abgeschlossen {
                    wunsch.abgeschlossen = true
                } else {
                    wunsch.abgeschlossen = false
                }
                showAlert = false
            }
            Button("Ja") {
                if wunsch.abgeschlossen {
                    wunsch.abgeschlossen = false
                    wunsch.gespart = 0
                } else {
                    wunsch.abgeschlossen = true
                    wunsch.gespart = wunsch.kosten
                }
                dismiss()
            }
        } message: {
            Text(wunsch.abgeschlossen ? "Der Wunsch taucht wieder bei den offenen Wünschen auf" : "Du kannst den Wunsch jederzeit wieder aus deinen abgeschlossenen Wünschen zurückholen")
        }
        
        
    }
}

struct BearbeitenOn: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var toggleGespart: Bool = false
    @State private var alertDelete: Bool = false
    
    @Binding var showAlert: Bool
    @Binding var bearbeiten: Bool
    @Binding var wunsch: WunschModel
    @Binding var wuensche: [WunschModel]
    
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
            
            Section("Gesamtkosten") {
                HStack {
                    Text("Kosten")
                    Spacer()
                    ZStack(alignment: .trailing) {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(Color.secondary.opacity(0.1))
                            .frame(width: 80)
                        TextField("0", value: $wunsch.kosten, formatter: NumberFormatter())
                            .multilineTextAlignment(.trailing)
                            .padding(.trailing)
                    }
                    Text("€")
                }
            }
            
            Section("Notizen") {
                TextEditor(text: $wunsch.notizen)
                    .frame(height: 160)
            }
            
//            if wunsch.abgeschlossen {
//                Button("Wunsch zurückholen") {
//                    showAlert.toggle()
//                }
//            } else {
//                Button("Wunsch erfüllt") {
//                    showAlert.toggle()
//                }
//            }
            
            Button("Artikel löschen") {
                alertDelete.toggle()
            }
            .foregroundStyle(.red)
            .frame(height: 30)
        }
        .navigationTitle("Detailansicht")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Fertig") {
                    withAnimation {
                        bearbeiten = false
                    }
                }
            }
        }
        .alert("Artikel löschen?", isPresented: $alertDelete) {
            Button("Nein", role: .cancel) {}
            Button("Ja", role: .destructive) {
                delete()
                dismiss()
            }
        } message: {
            Text("Du kannst den Artikel nach dem löschen nicht wiederherstellen. Bist du sicher das du ihn dennoch löschen willst?")
        }
    }
    
    //    $0.id == wunsch.id --> Finde das erste Element im Array "wuensche", dessen "id" mit der "id" des aktuellen wunsch übereinstimmt
    private func delete() {
        if let index = wuensche.firstIndex(where: { $0.id == wunsch.id }) {
            wuensche.remove(at: index)
        }
    }
}

#Preview {
    EditWunschSheetView(wunsch: .constant(WunschModel(name: "iPad Pro 11''", priority: .dringend, date: Date(), kosten: 1400)), wuensche: .constant([WunschModel(name: "", priority: .niedrig, date: .now, kosten: 0.0)]))
}
