//
//  WunschlisteView.swift
//  TestListApp
//
//  Created by Michael Ilic on 26.03.24.
//

import SwiftUI
import SwiftData

struct WunschlisteView: View {
    
    @State private var wuensche: [WunschModel] = [
        WunschModel(name: "iPad Pro 11''", priority: .dringend, date: Date(), kosten: 1400),
        WunschModel(name: "Test", priority: .niedrig, date: Date(), kosten: 100),
        WunschModel(name: "Opfer", priority: .hoch, date: Date(), kosten: 550)
    ]
    @State private var sortAsc: Bool = true
    @State private var filter: Priority?
    private var wunschListe: [WunschModel] {
        wuensche.sorted(by: {
            sortAsc ? $0.priority.rawValue > $1.priority.rawValue: $0.priority.rawValue < $1.priority.rawValue
        }).filter({
            guard let filter else { return true }
            return $0.priority == filter
        })
    }
    @State private var addSheet: Bool = false
    @State private var toggleSortButton: Bool = false
    @State private var filterSelected: Bool = false
    @State private var selectedFilter: String = ""
    
    @State private var expandOpen: Bool = true
    @State private var expandDone: Bool = false
    
    let listInfo: ListInfo
    
    var body: some View {
            ZStack {
                if wuensche.isEmpty {
                    EmptyStateView(sfSymbol: "star.fill", message: "Du hast im Moment keine Wünsche.\n Füge welche hinzu und verwirkliche deine Träume!")
                } else {
                    List {
                        Section(isExpanded: $expandOpen) {
                            ForEach(wunschListe, id: \.id) { wunsch in
                                if !wunsch.abgeschlossen {
                                    NavigationLink(value: wunsch) {
                                        WunschItemRow(wunsch: wunsch)
                                    }
                                }
                                // MARK: Funktioniert nicht, soll eine view sein wenn keine abgeschlossenen wünsche vorhanden sind
                                if wunsch.abgeschlossen.description.count <= 1 {
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text("Keine offenen Wünsche")
                                                .font(.headline)
                                                .padding(.bottom)
                                            Text("0 € angespart")
                                                .font(.subheadline)
                                        }
                                        .padding(.horizontal)
                                        Spacer()
                                        
                                        Gauge(value: 0) {
                                            Text("0%")
                                        }
                                        .gaugeStyle(.accessoryCircularCapacity)
                                        .tint(.black)
                                    }
                                }
                            }
                            .onDelete { offSet in
                                wuensche.remove(atOffsets: offSet)
                            }
                        } header: { Text("Offene Wünsche") }
                        
                        Section(isExpanded: $expandDone) {
                            ForEach(wunschListe, id: \.id) { wunsch in
                                if wunsch.abgeschlossen {
                                    NavigationLink(value: wunsch) {
                                        WunschItemRow(wunsch: wunsch)
                                    }
                                }
                            }
                        } header: { Text("Abgeschlossene Wünsche") }
                        
                    }
                    .background(Color(UIColor.systemGroupedBackground))
                    .listStyle(.sidebar)
                }
            }
            .navigationTitle("Wünsche")
            .navigationDestination(for: WunschModel.self) { wunsch in
                if let edit = $wuensche.first(where: { $0.id.wrappedValue == wunsch.id }) {
                    EditWunschSheetView(wunsch: edit, wuensche: $wuensche)
                }
            }
            
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    filterButton()
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    sortButton()
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    addButton()
                }
            }
            
            .sheet(isPresented: $addSheet) {
                AddWunschSheetView(wuensche: $wuensche)
                    .presentationDetents([.fraction(0.8)])
            }
            
            .toolbarBackground(listInfo.backgroundColor.opacity(0.6))
            .toolbarBackground(.visible, for: .navigationBar)
    }
    
    @ViewBuilder
    private func addButton() -> some View {
        Button(action: { addSheet.toggle() }, label: {
            Image(systemName: "plus.circle")
        })
    }
    
    @ViewBuilder
    private func sortButton() -> some View {
        Button { sortAsc.toggle() } label: {
            Image(systemName: toggleSortButton ? "arrow.up.arrow.down.circle.fill" : "arrow.up.arrow.down.circle")
        }
    }
    
    @ViewBuilder
    private func filterButton() -> some View {
        Menu {
            Button { filter = nil } label: {
                HStack {
                    Text("Alle")
                    if filter == nil {
                        Image(systemName: "checkmark")
                    }
                }
            }
            
            ForEach(Priority.allCases, id: \.self) { priority in
                Button {
                    filter = priority
                } label: {
                    HStack {
                        Text(priority.asString)
                        if filter == priority {
                            Image(systemName: "checkmark")
                        }
                    }
                }

            }
        } label: {
            Image(systemName: "line.3.horizontal.decrease.circle")
        }
    }
}

struct WunschItemRow: View {
    
    let wunsch: WunschModel
    
    var body: some View {
        HStack(spacing: 20) {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 5)
                .frame(maxHeight: .infinity)
                .foregroundStyle(wunsch.priority.color)
            
            VStack(alignment: .leading, spacing: 20) {
                Text(wunsch.name)
                    .font(.headline)
                Text("\(String(format: "%.0f", wunsch.gespart))€ angespart")
                    .font(.subheadline)
            }
            
            Spacer()
            
            Gauge(value: wunsch.gaugeProzent) {
                Text("\(String(format: "%.0f", wunsch.gaugeProzent * 100))%")
            }
            .gaugeStyle(.accessoryCircularCapacity)
            .tint(wunsch.priority.color)
        }
    }
}

#Preview {
    NavigationStack {
        WunschlisteView(listInfo: ListInfo(listName: "", systemName: "cart", itemsName: "Test", backgroundColor: .blue, accentColor: .white))
    }
}
