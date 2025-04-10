//
//  WunschlisteView.swift
//  TestListApp
//
//  Created by Michael Ilic on 26.03.24.
//

import SwiftUI
import SwiftData

struct WishlistView: View {
    
    @State private var wishes: [WishModel] = [
        WishModel(name: "iPad Pro 11''", priority: .dringend, date: Date(), cost: 1400),
        WishModel(name: "Test", priority: .niedrig, date: Date(), cost: 100),
        WishModel(name: "Opfer", priority: .hoch, date: Date(), cost: 550)
    ]
    @State private var sortAsc: Bool = true
    @State private var filter: Priority?
    private var wishesList: [WishModel] {
        wishes.sorted(by: {
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
    
    var body: some View {
            ZStack {
                if wishes.isEmpty {
                    EmptyStateView(sfSymbol: "star.fill", message: "Du hast im Moment keine Wünsche.\n Füge welche hinzu und verwirkliche deine Träume!")
                } else {
                    List {
                        Section(isExpanded: $expandOpen) {
                            ForEach(wishesList, id: \.id) { wish in
                                if !wish.isDone {
                                    NavigationLink(value: wish) {
                                        WishItemRow(wish: wish)
                                    }
                                }
                                // MARK: Funktioniert nicht, soll eine view sein wenn keine abgeschlossenen wünsche vorhanden sind
                                if wish.isDone.description.count <= 1 {
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
                                wishes.remove(atOffsets: offSet)
                            }
                        } header: { Text("Offene Wünsche") }
                        
                        Section(isExpanded: $expandDone) {
                            ForEach(wishesList, id: \.id) { wish in
                                if wish.isDone {
                                    NavigationLink(value: wish) {
                                        WishItemRow(wish: wish)
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
            .navigationDestination(for: WishModel.self) { wish in
                if let edit = $wishes.first(where: { $0.id.wrappedValue == wish.id }) {
                    EditWishSheet(wish: edit, wishes: $wishes)
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
                AddWishSheet(wishes: $wishes)
                    .presentationDetents([.fraction(0.8)])
            }
            
            .toolbarBackground(Color.tuerkis.opacity(0.6))
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

struct WishItemRow: View {
    
    let wish: WishModel
    
    var body: some View {
        HStack(spacing: 20) {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 5)
                .frame(maxHeight: .infinity)
                .foregroundStyle(wish.priority.color)
            
            VStack(alignment: .leading, spacing: 20) {
                Text(wish.name)
                    .font(.headline)
                Text("\(String(format: "%.0f", wish.saved))€ angespart")
                    .font(.subheadline)
            }
            
            Spacer()
            
            Gauge(value: wish.gaugePercent) {
                Text("\(String(format: "%.0f", wish.gaugePercent * 100))%")
            }
            .gaugeStyle(.accessoryCircularCapacity)
            .tint(wish.priority.color)
        }
    }
}

#Preview {
    NavigationStack {
        WishlistView()
    }
}
