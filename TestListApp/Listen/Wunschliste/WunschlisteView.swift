//
//  WunschlisteView.swift
//  TestListApp
//
//  Created by Michael Ilic on 26.03.24.
//

import SwiftUI
import SwiftData

enum Priority: CaseIterable, Comparable {
    case niedrig
    case mittel
    case hoch
    case dringend
    
    var asString: String {
        "\(self)".capitalized
    }
    
    var color: Color {
        switch self {
        case .niedrig: return .green
        case .mittel: return .blue
        case .hoch: return .orange
        case .dringend: return .red
        }
    }
}

enum Period: CaseIterable {
    case tag
    case woche
    case monat
    
    var asString: String {
        "\(self)".capitalized
    }
    
    var maxSliderVal: Int {
        switch self {
        case .tag: 31
        case .woche: 52
        case .monat: 12
        }
    }
}

class WunschModel: Identifiable, ObservableObject {
    var id = UUID()
    var name: String
    var priority: Priority
    var date: Date
    var kosten: String
    var gaugeProzent: Double
    var gaugeRing: Double
    
    init(id: UUID = UUID(), name: String, priority: Priority, date: Date, kosten: String, gaugeProzent: Double, gaugeRing: Double) {
        self.id = id
        self.name = name
        self.priority = priority
        self.date = date
        self.kosten = kosten
        self.gaugeProzent = gaugeProzent
        self.gaugeRing = gaugeRing
    }
    
    var kostenInsgesamt: Double {
        if let kostenValue = Double(kosten) {
            return (kostenValue / 100) * gaugeProzent
        } else {
            return 0
        }
    }
}

struct WunschlisteView: View {
    
    @State private var wuensche: [WunschModel] = [
        WunschModel(name: "iPad Pro 11''", priority: .dringend, date: Date(), kosten: "1400", gaugeProzent: 25.0, gaugeRing: 0.25),
        WunschModel(name: "Test", priority: .niedrig, date: Date(), kosten: "100", gaugeProzent: 50.0, gaugeRing: 0.50),
        WunschModel(name: "Opfer", priority: .hoch, date: Date(), kosten: "550", gaugeProzent: 75.0, gaugeRing: 0.75)
    ].sorted { $0.priority > $1.priority }
    
    @State private var addSheet: Bool = false
    @State private var gaugeProzent: Double = 0.0
    @State private var gaugeRing: Double = 0.0
    @State private var sortButton: Bool = false
    @State private var prioPicker: Priority = Priority.niedrig
    @State private var wunschDatum = Date()
    
    @State private var filterSelected: Bool = false
    @State private var selectedFilter: String = ""
    
    let listInfo: ListInfo
    
    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    Section("") {
                        ForEach(wuensche.indices, id:\.self) { index in
                            NavigationLink {
                                EditWunschSheetView(prioPicker: $wuensche[index].priority, gaugeProzent: $wuensche[index].gaugeProzent, gaugeRing: $wuensche[index].gaugeRing, wunschDatum: $wuensche[index].date, nameTextField: $wuensche[index].name, kosten: $wuensche[index].kosten, wunsch: wuensche[index])
                            } label: {
                                WunschItemRow(gaugeProzent: $wuensche[index].gaugeProzent, gaugeRing: $wuensche[index].gaugeRing, wunsch: wuensche[index])
                                    .onAppear {
                                        if sortButton {
                                            wuensche.sort { $0.priority < $1.priority }
                                        } else {
                                            wuensche.sort { $0.priority > $1.priority }
                                        }
                                        
                //MARK: Hier kommt die compiler Fehlermeldung
//                                        if filterSelected {
//                                            wuensche.filter(selectedFilter)
//                                        } else {
//                                            Text("Hi")
//                                        }
                                    }
                            }
                        }
                        .onDelete { offSet in
                            wuensche.remove(atOffsets: offSet)
                        }
                    }
                }
                .background(Color(UIColor.systemGroupedBackground))
                .listStyle(.insetGrouped)
                
                if wuensche.isEmpty {
                    EmptyStateView(sfSymbol: "star.fill", message: "Du hast im Moment keine Wünsche.\n Füge welche hinzu und verwirkliche deine Träume!")
                }
            }
            .navigationTitle("Wunschliste")
            .toolbar {
                
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        ForEach(Priority.allCases, id: \.self) { priority in
                            Button {
                                selectedFilter = priority.asString
                            } label: {
                                if filterSelected {
                                    HStack {
                                        Text(priority.asString)
                                        if priority.asString == selectedFilter {
                                            Image(systemName: "checkmark")
                                        }
                                    }
                                } else {
                                    Text(priority.asString)
                                }
                            }

                        }
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    }

//                    Button(action: {}) {
//                        Image(systemName: "line.3.horizontal.decrease.circle")
//                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        sortButton.toggle()
                        if sortButton == true {
                            wuensche.sort { $0.priority < $1.priority }
                        } else {
                            wuensche.sort { $0.priority > $1.priority }
                        }
                    } label: {
                        Image(systemName: sortButton ? "arrow.up.arrow.down.circle.fill" : "arrow.up.arrow.down.circle")
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { addSheet.toggle() }, label: {
                        Image(systemName: "plus.circle")
                    })
                }
            }
            
            .sheet(isPresented: $addSheet) {
                AddWunschSheetView(gaugeRing: $gaugeRing, gaugeProzent: $gaugeProzent, wunschDatum: $wunschDatum, prioPicker: $prioPicker, wuensche: $wuensche)
                    .presentationDetents([.fraction(0.8)])
            }
            
            .toolbarBackground(listInfo.backgroundColor.opacity(0.6))
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}

struct WunschItemRow: View {
    
    @Binding var gaugeProzent: Double
    @Binding var gaugeRing: Double
    
    let wunsch: WunschModel
    
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 5)
                .frame(maxHeight: .infinity)
                .foregroundStyle(wunsch.priority.color)
            
            VStack(alignment: .leading) {
                Text(wunsch.name)
                    .font(.headline)
                    .padding(.bottom)
                Text("\(String(format: "%.0f", wunsch.kostenInsgesamt))€ angespart")
                    .font(.subheadline)
            }
            .padding(.horizontal)
            Spacer()
            
            Gauge(value: gaugeRing) {
                Text("\(String(format: "%.0f", gaugeProzent))%")
            }
            .gaugeStyle(.accessoryCircularCapacity)
            .tint(wunsch.priority.color)
        }
    }
}

#Preview {
    WunschlisteView(listInfo: ListInfo(listName: "", backgroundColor: .blue, accentColor: .white))
}
