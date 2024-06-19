//
//  EinkauflisteDetailView.swift
//  TestListApp
//
//  Created by Michael Ilic on 02.02.24.
//
//
//import SwiftUI
//import SwiftData
//
//struct EinkaufslisteDetailView: View {
//    
//    @Environment (\.modelContext) var context
//    
//    @Query var items: [EinkaufModel]
//    @State private var isDone: Bool = false
//    @State private var anzahl: Int = 5
//    @State private var textFieldText: String = ""
//    
//    let kategorieName: String
//    
//    var body: some View {
//        NavigationStack {
//            List {
//                ForEach(items) { item in
//                    //NavigationLink(destination: TestEditView(user: item)) {
//                    EinkaufItemRowView(model: item)
//                        .padding(.vertical)
//                    //}
//                }
//                .onDelete { indexSet in
//                    for index in indexSet {
//                        context.delete(items[index])
//                    }
//                }
//            }
//            .listStyle(.plain)
//            .navigationBarItems(
//                trailing: Button(action: { addItem(context: context) },
//                                 label: {
//                                     Image(systemName: "plus.circle")
//                                         .resizable()
//                                         .frame(width: 30, height: 30)
//                                 })
//            )
//            .navigationTitle(kategorieName)
//        }
//    }
//    func addItem(context: ModelContext) {
//        let newItem = EinkaufModel(name: "", anzahl: 0)
//        context.insert(newItem)
//    }
//}
//
//#Preview {
//    EinkaufslisteDetailView(kategorieName: "Testname")
//        .modelContainer(EinkaufModel.preview)
//}
//
//struct EinkaufItemRowView: View {
//    
//    @Bindable var model: EinkaufModel
//    let testName = "Neuer Artikel"
//    @State private var isDone: Bool = false
//    
//    var body: some View {
//        HStack {
//            Image(systemName: isDone ? "checkmark.circle.fill" : "checkmark.circle")
//                .resizable()
//                .frame(width: 30, height: 30)
//                .foregroundStyle(isDone ? .green : .primary)
//                .padding(.horizontal)
//                .onTapGesture {
//                    isDone.toggle()
//                }
//            
//            if model.name.isEmpty {
//                TextField(testName, text: $model.name)
//                    .strikethrough(isDone ? true : false)
//                    .font(.title2)
//                    .foregroundStyle(Color.gray.opacity(0.5))
//            } else {
//                TextField(model.name, text: $model.name)
//                    .strikethrough(isDone ? true : false)
//                    .font(.title2)
//                    .foregroundStyle(isDone ? .gray : .primary)
//            }
//            
//            Spacer()
//            
//            Image(systemName: "minus.circle")
//                .resizable()
//                .foregroundStyle(.red)
//                .frame(width: 30, height: 30)
//                .onTapGesture {
//                    guard model.anzahl >= 1 else { return }
//                    model.anzahl -= 1
//                }
//            
//            Image(systemName: "plus.circle")
//                .resizable()
//                .foregroundStyle(.green)
//                .frame(width: 30, height: 30)
//                .onTapGesture {
//                    model.anzahl += 1
//                }
//            
//            Text("\(model.anzahl)")
//                .frame(width: 40)
//                .padding(.horizontal, 5)
//                .font(.title2)
//                .bold()
//            
//        }
//    }
//}
