//
//  EditWunschSheet.swift
//  TestListApp
//
//  Created by Michael Ilic on 10.04.24.
//

import SwiftUI

struct EditWishSheet: View {
    
    @Namespace private var ns
    
    @State private var testToggle: Bool = false
    @State private var showAlert: Bool = false
    @State private var editView: Bool = true
    
    @Binding var wish: WishModel
    @Binding var wishes: [WishModel]
    
    var body: some View {
        if editView {
            EditViewOn(showAlert: $showAlert, editView: $editView, wish: $wish, wishes: $wishes)
        } else {
            EditViewOff(showAlert: $showAlert, editView: $editView, wish: $wish)
        }
    }
}

struct EditViewOff: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Binding var showAlert: Bool
    @Binding var editView: Bool
    @Binding var wish: WishModel
    
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
                    Text(wish.name)
                }
                
                HStack {
                    Text("Priorität")
                    Spacer()
                    Text("\(wish.priority.asString)")
                        .foregroundStyle(wish.priority.color)
                }
                
                HStack {
                    Text("Wunschtermin")
                    Spacer()
                    Text("\(wish.date, formatter: dateFormatter)")
                }
            }
            
            Section("Ersparnis") {
                HStack {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("€")
                            TextField("Ersparnis", value: $wish.saved, formatter: NumberFormatter())
                                .onChange(of: wish.saved) {
                                    if wish.saved > wish.cost {
                                        wish.saved = wish.cost
                                    }
                                    if wish.cost <= -1 {
                                        wish.cost = 0
                                    }
                                }
                        }
                        Text("Gesamtkosten: \(String(format: "%.0f", wish.cost))€")
                            .font(.footnote)
                    }
                    Spacer()
                    
                    Gauge(value: wish.gaugePercent) {
                        Text("\(String(format: "%.0f", wish.gaugePercent * 100))%")
                    }
                    .gaugeStyle(.accessoryCircularCapacity)
                    .tint(wish.priority.color)
                    
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
                TextEditor(text: $wish.notes)
                    .frame(height: 160)
            }
            
            if wish.isDone {
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
                        editView.toggle()
                    }
                }
            }
        }
        
        .alert(wish.isDone ? "Wunsch zurückholen" : "Wunsch erfüllt?", isPresented: $showAlert) {
            Button("Nein", role: .cancel) {
                if wish.isDone {
                    wish.isDone = true
                } else {
                    wish.isDone = false
                }
                showAlert = false
            }
            Button("Ja") {
                if wish.isDone {
                    wish.isDone = false
                    wish.saved = 0
                } else {
                    wish.isDone = true
                    wish.saved = wish.cost
                }
                dismiss()
            }
        } message: {
            Text(wish.isDone ? "Der Wunsch taucht wieder bei den offenen Wünschen auf" : "Du kannst den Wunsch jederzeit wieder aus deinen abgeschlossenen Wünschen zurückholen")
        }
        
        
    }
}

struct EditViewOn: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var toggleSaved: Bool = false
    @State private var alertDelete: Bool = false
    
    @Binding var showAlert: Bool
    @Binding var editView: Bool
    @Binding var wish: WishModel
    @Binding var wishes: [WishModel]
    
    var body: some View {
        Form {
            Section("Artikeldetail") {
                TextField("", text: $wish.name)
            }
            
            Section("Priorität") {
                PriorityPicker(prioPicker: $wish.priority)
            }
            
            Section("Zeitraum") {
                DatePicker("Wunschtermin", selection: $wish.date, displayedComponents: .date)
            }
            
            Section("Gesamtkosten") {
                HStack {
                    Text("Kosten")
                    Spacer()
                    ZStack(alignment: .trailing) {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(Color.secondary.opacity(0.1))
                            .frame(width: 80)
                        TextField("0", value: $wish.cost, formatter: NumberFormatter())
                            .multilineTextAlignment(.trailing)
                            .padding(.trailing)
                    }
                    Text("€")
                }
            }
            
            Section("Notizen") {
                TextEditor(text: $wish.notes)
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
                        editView = false
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
        if let index = wishes.firstIndex(where: { $0.id == wish.id }) {
            wishes.remove(at: index)
        }
    }
}

#Preview {
    EditWishSheet(wish: .constant(WishModel(name: "iPad Pro 11''", priority: .dringend, date: Date(), cost: 1400)), wishes: .constant([WishModel(name: "", priority: .niedrig, date: .now, cost: 0.0)]))
}
