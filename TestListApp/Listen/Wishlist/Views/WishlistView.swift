//
//  WunschlisteView.swift
//  TestListApp
//
//  Created by Michael Ilic on 26.03.24.
//

import SwiftUI
import SwiftData

struct WishlistView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    
    @State private var selectedFilter: String = ""
    @State private var searchText: String = ""
    
    @State private var sortAsc: Bool = true
    @State private var filterSelected: Bool = false
    @State private var addSheet: Bool = false
    @State private var toggleSortButton: Bool = false
    @State private var expandOpen: Bool = true
    @State private var expandDone: Bool = false
    
    @State private var filter: Priority?
    @State private var filterOn: Bool = false
    
    @Query(sort: [
        SortDescriptor(\WishModel.priorityRaw),
        SortDescriptor(\WishModel.name, order: .forward)
    ]) var wishes: [WishModel]
    
    private var sortedWishes: [WishModel] {
        wishes.sorted {
            sortAsc ? $0.gaugePercent > $1.gaugePercent : $0.gaugePercent < $1.gaugePercent
        }
    }
    
    private var filteredAndSortedWish: [WishModel] {
        if filter == .niedrig {
            return sortedWishes.filter { wish in
                wish.priority == filter
            }
        } else if filter == .mittel {
            return sortedWishes.filter { wish in
                wish.priority == filter
            }
        } else if filter == .hoch {
            return sortedWishes.filter { wish in
                wish.priority == filter
            }
        } else if filter == .dringend {
            return sortedWishes.filter { wish in
                wish.priority == filter
            }
        } else {
            return sortedWishes
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                if wishes.isEmpty {
                    ContentUnavailableView("Du hast im Moment keine Wünsche.\n Füge welche hinzu und verwirkliche deine Träume!", systemImage: "star.fill")
                } else {
                    List {
                        Section(isExpanded: $expandOpen) {
                            ForEach(filteredAndSortedWish) { wish in
                                if !wish.isDone {
                                    NavigationLink(value: wish) {
                                        WishItemRow(wish: wish)
                                    }
                                }
//                                if wunsch.abgeschlossen.description.count <= 1 {
//                                    HStack {
//                                        VStack(alignment: .leading) {
//                                            Text("Keine offenen Wünsche")
//                                                .font(.headline)
//                                                .padding(.bottom)
//                                            Text("0 € angespart")
//                                                .font(.subheadline)
//                                        }
//                                        .padding(.horizontal)
//                                        Spacer()
//
//                                        Gauge(value: 0) {
//                                            Text("0%")
//                                        }
//                                        .gaugeStyle(.accessoryCircularCapacity)
//                                        .tint(.black)
//                                    }
//                                }
                            }
                            .onDelete(perform: deleteWish)
                        } header: { Text("Offene Wünsche") }
                        
                        Section(isExpanded: $expandDone) {
                            ForEach(sortedWishes) { wish in
                                if wish.isDone {
                                    NavigationLink(value: wish) {
                                        WishItemRow(wish: wish)
                                    }
                                }
                            }
                            .onDelete(perform: deleteWish)
                        } header: { Text("Abgeschlossene Wünsche") }
                        
                    }
                    .background(Color(UIColor.systemGroupedBackground))
                    .listStyle(.sidebar)
                }
            }
            .navigationTitle("Wunschliste")
            .navigationDestination(for: WishModel.self) { wish in
                if let edit = wishes.first(where: { $0.id == wish.id }) {
                    EditWishSheet(wish: edit, deleteWish: {
                        if let index = wishes.firstIndex(of: edit) {
                            context.delete(wishes[index])
                        }
                    })
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    filterButton()
                    
                }
                
                ToolbarItem(placement: .topBarTrailing) {
//                    sortButton()
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    addButton()
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark.circle")
                    }
                }
            }
            
            .sheet(isPresented: $addSheet) {
                AddWishSheet()
                    .presentationDetents([.fraction(0.8)])
            }
            
            .toolbarBackground(.purple.opacity(0.6))
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
    
    private func deleteWish(indexSet: IndexSet) {
        for index in indexSet {
            context.delete(wishes[index])
        }
    }
    
    @ViewBuilder
    private func addButton() -> some View {
        Button(action: { addSheet.toggle() }, label: {
            Image(systemName: "plus.circle")
        })
    }
    
//    @ViewBuilder
//    private func sortButton() -> some View {
//        Button("", systemImage: "arrow.up.arrow.down.circle") {
//            sortAsc.toggle()
//        }
//        .symbolVariant(sortAsc ? .none : .fill)
//    }
    
    // - Das hier ist für die Auswahl nach was man sortieren möchte - funktioniert noch nicht ganz
//    @ViewBuilder
//    private func sortButton() -> some View {
//        Menu("", systemImage: "arrow.up.arrow.down.circle") {
//            Picker("Sort", selection: $sortOrder) {
//                Text("Sortiere nach kosten")
//                    .tag(SortDescriptor(\WunschModel.kosten))
//
//                Text("Sortieren nach Name")
//                    .tag(SortDescriptor(\WunschModel.name))
//            }
//            .pickerStyle(.inline)
//        }
//    }
    
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
        HStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 5)
                .frame(maxHeight: .infinity)
                .foregroundStyle(wish.priority.color)
            
            VStack(alignment: .leading) {
                Text(wish.name)
                    .font(.headline)
                    .padding(.bottom)
                Text("\(String(format: "%.0f", wish.saved))€ angespart")
                    .font(.subheadline)
            }
            .padding(.horizontal)
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
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: WishModel.self, configurations: config)
    
    let wish = WishModel(name: "1", priority: .mittel, date: .now, cost: 200)
    let wish2 = WishModel(name: "2", priority: .niedrig, date: .now, cost: 400)
    let wish3 = WishModel(name: "3", priority: .dringend, date: .now, cost: 400)
    let wish4 = WishModel(name: "4", priority: .hoch, date: .now, cost: 400)
    let wish5 = WishModel(name: "5", priority: .mittel, date: .now, cost: 400)
    container.mainContext.insert(wish)
    container.mainContext.insert(wish2)
    container.mainContext.insert(wish3)
    container.mainContext.insert(wish4)
    container.mainContext.insert(wish5)
    
    return WishlistView()
        .modelContainer(container)
}
