//
//  Einkaufsliste.swift
//  TestListApp
//
//  Created by Michael Ilic on 02.02.24.
//

import SwiftUI
import SwiftData

enum Gruppe: String, CaseIterable, Identifiable {
    var id: String { self.rawValue}
    
    case produktgruppe, supermarkt
    
    func gruppenName() -> String {
        switch self {
        case .produktgruppe: return "Produktgruppe"
        case .supermarkt: return "Supermarkt"
        }
    }
}

//@Model
class ListenArray: ObservableObject {
    var kategorie: String
    var arrays: [String]
    var gruppe: Gruppe
    //@Published var anzahl: Int
    //var isDone: [String: Bool]
    
    init(kategorie: String, arrays: [String], gruppe: Gruppe/*, anzahl: Int, isDone: [String : Bool]*/) {
        self.kategorie = kategorie
        self.arrays = arrays
        self.gruppe = gruppe
        //self.anzahl = anzahl
        //self.isDone = isDone
    }
}

/*struct Einkaufsliste: View {
 
 @Environment (\.modelContext) var context
 
 @State var liste: [ListenArray] = [
 ListenArray(kategorie: "Obst", arrays: ["🍎 Apfel", "🍐 Birne"], gruppe: .produktgruppe),
 ListenArray(kategorie: "Fleisch", arrays: ["🍗 Hühnerfleisch", "🥩 Schweinefleisch"], gruppe: .produktgruppe),
 ListenArray(kategorie: "Hofer", arrays: ["⚡️ Flying Power"], gruppe: .supermarkt)
 ]
 
 @State var showSheet: Bool = false
 @Query var items2: [EinkaufModel]
 let navTitle: String
 @Binding var accentColor: Color
 @Binding var backgroundColor: Color
 @State private var testAnzahl: Int = 0
 let listInfo: ListInfo
 
 var body: some View {
 NavigationStack {
 ScrollView {
 HStack {
 VStack {
 Section {
 ForEach(liste.indices, id: \.self) { index in
 let item = liste[index]
 if item.gruppe == .produktgruppe {
 NavigationLink {
 //EinkaufslisteDetailView(kategorieName: item.title)
 EinkaufslisteDetailView2(listenArray: liste[index], kategorieName: $liste[index].kategorie, testAnzahl: $testAnzahl)
 Divider()
 } label: {
 let anzahl = liste[index].arrays.count
 ZStack {
 RoundedRectangle(cornerRadius: 15)
 .stroke()
 
 HStack {
 Image(systemName: "apple.logo")
 .padding(.horizontal)
 
 Spacer()
 
 Text(liste[index].kategorie)
 
 Spacer()
 
 Text("\(testAnzahl)")
 .opacity(0)
 
 ZStack {
 RoundedRectangle(cornerRadius: 10)
 .stroke()
 .frame(width: 40, height: 40)
 Text("\(anzahl)")
 }
 
 Image(systemName: "arrow.right")
 .padding()
 }
 }
 .accentColor(listInfo.backgroundColor)
 .font(.title2)
 .fontWeight(.bold)
 .frame(width: 350, height: 60)
 .background(.gray.opacity(0.3))
 .cornerRadius(15)
 }
 //.buttonStyle(.plain)
 .onAppear {
 testAnzahl = liste[index].arrays.count
 }
 }
 
 //.foregroundStyle(item.titleColor)
 }
 } header: {
 Text("Produktgruppe")
 }
 
 
 /*Section {
  NavigationLink {
  ForEach(liste.indices, id: \.self) { index in
  EinkaufslisteDetailView3(listenArray: liste[index], kategorieName: $liste[index].kategorie, testAnzahl: $testAnzahl)
  }
  } label: {
  ZStack() {
  RoundedRectangle(cornerRadius: 15)
  .stroke()
  
  HStack {
  Image(systemName: "apple.logo")
  .padding(.horizontal)
  
  Spacer()
  
  Text("Hofer")
  
  Spacer()
  
  Text("0")
  .opacity(0)
  
  ZStack {
  RoundedRectangle(cornerRadius: 10)
  .stroke()
  .frame(width: 40, height: 40)
  Text("0")
  }
  
  Image(systemName: "arrow.right")
  .padding()
  }
  }
  .accentColor(listInfo.backgroundColor)
  .font(.title2)
  .fontWeight(.bold)
  .frame(width: 350, height: 60)
  .background(.gray.opacity(0.3))
  .cornerRadius(15)
  .padding(.top)
  }
  } header: {
  Text("Supermärkte")
  .padding(.top)
  }*/
 
 Section {
 ForEach(liste.indices, id: \.self) { index in
 let item = liste[index]
 if item.gruppe == .supermarkt {
 NavigationLink {
 //EinkaufslisteDetailView(kategorieName: item.title)
 EinkaufslisteDetailView2(listenArray: liste[index], kategorieName: $liste[index].kategorie, testAnzahl: $testAnzahl)
 Divider()
 } label: {
 let anzahl = liste[index].arrays.count
 ZStack {
 RoundedRectangle(cornerRadius: 15)
 .stroke()
 
 HStack {
 Image(systemName: "apple.logo")
 .padding(.horizontal)
 
 Spacer()
 
 Text(liste[index].kategorie)
 
 Spacer()
 
 Text("\(testAnzahl)")
 .opacity(0)
 
 ZStack {
 RoundedRectangle(cornerRadius: 10)
 .stroke()
 .frame(width: 40, height: 40)
 Text("\(anzahl)")
 }
 
 Image(systemName: "arrow.right")
 .padding()
 }
 }
 .accentColor(listInfo.backgroundColor)
 .font(.title2)
 .fontWeight(.bold)
 .frame(width: 350, height: 60)
 .background(.gray.opacity(0.3))
 .cornerRadius(15)
 }
 //.buttonStyle(.plain)
 .onAppear {
 testAnzahl = liste[index].arrays.count
 }
 }
 
 //.foregroundStyle(item.titleColor)
 }
 } header: {
 Text("Supermarkt")
 .padding(.top)
 }
 }
 }
 }
 .navigationBarItems(
 trailing: Button(action: { showSheet.toggle() }, label: {
 Image(systemName: "plus.circle")
 .resizable()
 .frame(width: 30, height: 30)
 })
 .sheet(isPresented: $showSheet) {
 AddKategorie(listenArray: $liste, showSheet: $showSheet)
 .presentationDetents([.fraction(0.6)])
 }
 )
 
 //MARK: Hier beginnt ein Test
 /*.navigationBarItems(
  trailing: Button(action: {
  let newItem = ListenArray(kategorie: "Birne", arrays: [], anzahl: 0, isDone: [:])
  liste.append(newItem)
  }, label: {
  Image(systemName: "plus.circle")
  .resizable()
  .frame(width: 30, height: 30)
  })
  )*/
 /*.navigationBarItems(
  trailing: Button(action: { showSheet.toggle() }, label: {
  Image(systemName: "plus.circle")
  .resizable()
  .frame(width: 30, height: 30)
  })
  .sheet(isPresented: $showSheet) {
  AddKategorie()
  .presentationDetents([.fraction(0.5)])
  }
  )*/
 
 //MARK: Hier endet der Test
 .navigationTitle(navTitle)
 
 }
 }
 
 /*func addNewTestArray() {
  let newArray = ListenArray(kategorie: [newListenArrayKategorien], arrays: [], anzahl: 0, isDone: [newListenArrayKategorien : false])
  //let newArray = ListenArraysss(kategorien: [newListenArrayKategorien], arrays: [])
  context.insert(newArray)
  newListenArrayKategorien = ""
  }*/
 
 }*/

/*struct EinkaufslisteDetailView3: View {
 
 @State private var isDone: Bool = false
 @Environment (\.modelContext) var context
 @ObservedObject var listenArray: ListenArray
 @Binding var kategorieName: String
 @Binding var testAnzahl: Int
 
 var body: some View {
 NavigationStack {
 List {
 ForEach(listenArray.arrays.indices, id:\.self) { index in
 EinkaufItemRowView3(listenName: $listenArray.arrays[index])
 }
 .onDelete { indexSet in
 for index in indexSet {
 listenArray.arrays.remove(at: index)
 testAnzahl -= 1
 }
 }
 }
 .listStyle(.insetGrouped)
 
 //MARK: Das hier ist ein weiterer Test
 .navigationBarItems(trailing: Button(action: {
 let newItem = EinkaufModel(name: "Test", anzahl: 0)
 //context.insert(newItem)
 listenArray.arrays.append(newItem.name)
 listenArray.objectWillChange.send()
 testAnzahl += 1
 }, label: {
 Image(systemName: "plus.circle")
 .resizable()
 .frame(width: 30, height: 30)
 }))
 //MARK: Hier endet der Test
 
 .navigationTitle(kategorieName)
 }
 }
 }*/


struct Einkaufsliste: View {
    
    @Environment (\.modelContext) var context
    
    @State var liste: [ListenArray] = [
        ListenArray(kategorie: "Obst", arrays: ["🍎 Apfel", "🍐 Birne"], gruppe: .produktgruppe),
        ListenArray(kategorie: "Fleisch", arrays: ["🍗 Hühnerfleisch", "🥩 Schweinefleisch"], gruppe: .produktgruppe),
        ListenArray(kategorie: "Hofer", arrays: ["⚡️ Flying Power"], gruppe: .supermarkt)
    ]
    
    @State var showSheet: Bool = false
    @State private var testAnzahl: Int = 0
    @Query var items2: [EinkaufModel]
    @Binding var accentColor: Color
    @Binding var backgroundColor: Color
    let navTitle: String
    let listInfo: ListInfo
    
    var body: some View {
        NavigationStack {
            ScrollView {
                //VStack {
                Section {
                    HStack {
                        ForEach(liste.indices, id: \.self) { index in
                            let item = liste[index]
                            if item.gruppe == .produktgruppe {
                                NavigationLink {
                                    //EinkaufslisteDetailView(kategorieName: item.title)
                                    EinkaufslisteDetailView(listenArray: liste[index], kategorieName: $liste[index].kategorie, testAnzahl: $testAnzahl)
                                    Divider()
                                } label: {
                                    let anzahl = liste[index].arrays.count
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke()
                                        
                                        VStack(alignment: .leading) {
                                            HStack {
                                                Image(systemName: "apple.logo")
                                                    .padding(.horizontal)
                                                
                                                Spacer()
                                                
                                                Text("\(testAnzahl)")
                                                    .font(.caption2)
                                                    .opacity(0)
                                                
                                                ZStack {
                                                    RoundedRectangle(cornerRadius: 10)
                                                        .stroke()
                                                        .frame(width: 40, height: 40)
                                                    Text("\(anzahl)")
                                                }
                                                .padding()
                                                
                                                //Image(systemName: "arrow.right")
                                                //  .padding()
                                            }
                                            
                                            Text(liste[index].kategorie)
                                            //.font(.subheadline)
                                                .padding()
                                        }
                                        .accentColor(listInfo.accentColor)
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .frame(maxWidth: .infinity)
                                        //.frame(width: 350, height: 60)
                                        .background(listInfo.backgroundColor)
                                        //.background(.gray.opacity(0.3))
                                        .cornerRadius(15)
                                        
                                    }
                                }
                                //.buttonStyle(.plain)
                                .onAppear {
                                    testAnzahl = liste[index].arrays.count
                                }
                            }
                            
                            //.foregroundStyle(item.titleColor)
                        }
                    }
                } header: {
                    Text("Produktgruppe")
                }
                
                /*Section {
                 NavigationLink {
                 ForEach(liste.indices, id: \.self) { index in
                 EinkaufslisteDetailView3(listenArray: liste[index], kategorieName: $liste[index].kategorie, testAnzahl: $testAnzahl)
                 }
                 } label: {
                 ZStack() {
                 RoundedRectangle(cornerRadius: 15)
                 .stroke()
                 
                 HStack {
                 Image(systemName: "apple.logo")
                 .padding(.horizontal)
                 
                 Spacer()
                 
                 Text("Hofer")
                 
                 Spacer()
                 
                 Text("0")
                 .opacity(0)
                 
                 ZStack {
                 RoundedRectangle(cornerRadius: 10)
                 .stroke()
                 .frame(width: 40, height: 40)
                 Text("0")
                 }
                 
                 Image(systemName: "arrow.right")
                 .padding()
                 }
                 }
                 .accentColor(listInfo.backgroundColor)
                 .font(.title2)
                 .fontWeight(.bold)
                 .frame(width: 350, height: 60)
                 .background(.gray.opacity(0.3))
                 .cornerRadius(15)
                 .padding(.top)
                 }
                 } header: {
                 Text("Supermärkte")
                 .padding(.top)
                 }*/
                
                Section {
                    ForEach(liste.indices, id: \.self) { index in
                        let item = liste[index]
                        if item.gruppe == .supermarkt {
                            NavigationLink {
                                //EinkaufslisteDetailView(kategorieName: item.title)
                                EinkaufslisteDetailView(listenArray: liste[index], kategorieName: $liste[index].kategorie, testAnzahl: $testAnzahl)
                                Divider()
                            } label: {
                                let anzahl = liste[index].arrays.count
                                ZStack {
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke()
                                    
                                    HStack {
                                        Image(systemName: "apple.logo")
                                            .padding(.horizontal)
                                        
                                        Spacer()
                                        
                                        Text(liste[index].kategorie)
                                        
                                        Spacer()
                                        
                                        Text("\(testAnzahl)")
                                            .opacity(0)
                                        
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke()
                                                .frame(width: 40, height: 40)
                                            Text("\(anzahl)")
                                        }
                                        
                                        Image(systemName: "arrow.right")
                                            .padding()
                                    }
                                }
                                .accentColor(Color.black)
                                .font(.title2)
                                .fontWeight(.bold)
                                .frame(width: 350, height: 60)
                                .background(listInfo.backgroundColor.opacity(1))
                                .cornerRadius(15)
                            }
                            //.buttonStyle(.plain)
                            .onAppear {
                                testAnzahl = liste[index].arrays.count
                            }
                        }
                        
                        //.foregroundStyle(item.titleColor)
                    }
                    
                    ForEach(liste.indices, id: \.self) { index in
                        let item = liste[index]
                        if item.gruppe == .supermarkt {
                            NavigationLink {
                                //EinkaufslisteDetailView(kategorieName: item.title)
                                EinkaufslisteDetailView(listenArray: liste[index], kategorieName: $liste[index].kategorie, testAnzahl: $testAnzahl)
                                Divider()
                            } label: {
                                let anzahl = liste[index].arrays.count
                                ZStack {
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke()
                                    
                                    HStack {
                                        Image(systemName: "apple.logo")
                                            .padding(.horizontal)
                                        
                                        Spacer()
                                        
                                        Text(liste[index].kategorie)
                                        
                                        Spacer()
                                        
                                        Text("\(testAnzahl)")
                                            .opacity(0)
                                        
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke()
                                                .frame(width: 40, height: 40)
                                            Text("\(anzahl)")
                                        }
                                        
                                        Image(systemName: "arrow.right")
                                            .padding()
                                    }
                                }
                                .accentColor(Color.white)
                                .font(.title2)
                                .fontWeight(.bold)
                                .frame(width: 350, height: 60)
                                .background(listInfo.backgroundColor.opacity(0.8))
                                .cornerRadius(15)
                            }
                            //.buttonStyle(.plain)
                            .onAppear {
                                testAnzahl = liste[index].arrays.count
                            }
                            
                            //.foregroundStyle(item.titleColor)
                        }
                    }
                } header: {
                    Text("Supermarkt")
                        .padding(.top)
                }
                //}
            }
        }
        .navigationBarItems(
            trailing: Button(action: { showSheet.toggle() }, label: {
                Image(systemName: "plus.circle")
            })
            .sheet(isPresented: $showSheet) {
                AddKategorie(listenArray: $liste, showSheet: $showSheet)
                    .presentationDetents([.fraction(0.6)])
            }
        )
        
        .toolbarBackground(listInfo.backgroundColor, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        
        //MARK: Hier beginnt ein Test
        /*.navigationBarItems(
         trailing: Button(action: {
         let newItem = ListenArray(kategorie: "Birne", arrays: [], anzahl: 0, isDone: [:])
         liste.append(newItem)
         }, label: {
         Image(systemName: "plus.circle")
         .resizable()
         .frame(width: 30, height: 30)
         })
         )*/
        /*.navigationBarItems(
         trailing: Button(action: { showSheet.toggle() }, label: {
         Image(systemName: "plus.circle")
         .resizable()
         .frame(width: 30, height: 30)
         })
         .sheet(isPresented: $showSheet) {
         AddKategorie()
         .presentationDetents([.fraction(0.5)])
         }
         )*/
        
        //MARK: Hier endet der Test
        .navigationTitle(navTitle)
    }
}

struct EinkaufslisteDetailView: View {
    
    @Environment (\.modelContext) var context
    @ObservedObject var listenArray: ListenArray
    @Binding var kategorieName: String
    @Binding var testAnzahl: Int
    
    var body: some View {
        NavigationStack {
            List {
                DisclosureGroup(
                    content: {
                        ForEach(listenArray.arrays.indices, id:\.self) { index in
                            EinkaufItemRowView(listenName: $listenArray.arrays[index], listenArray: listenArray)
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                //let itemToRemove = model[index]
                                // Führen Sie hier die Löschoperation durch, die auf Ihrem Datenmodell basiert
                                // Zum Beispiel:
                                //context.delete(itemToRemove) // Falls Sie Core Data verwenden
                                listenArray.arrays.remove(at: index) // Falls Sie ein einfaches Swift-Array verwenden
                                testAnzahl -= 1
                            }
                        }
                        
                        Button {
                            let newItem = EinkaufModel(name: "Test", anzahl: 3)
                            withAnimation {
                                listenArray.arrays.append(newItem.name)
                                listenArray.objectWillChange.send()
                            }
                        } label: {
                            Label("Add", systemImage: "plus")
                        }
                    }, label: {
                        Text("Getränke")
                            .fontWeight(.semibold)
                    })
                
                
                /*ForEach(items) { item in
                 //NavigationLink(destination: TestEditView(user: item)) {
                 EinkaufItemRowView(model: item)
                 .padding(.vertical)
                 //}
                 }*/
                /*.onDelete { indexSet in
                 for index in indexSet {
                 context.delete(items[index])
                 }
                 }*/
                
            }
            .listStyle(.insetGrouped)
            
            //MARK: Das hier ist ein weiterer Test
            .navigationBarItems(trailing: Button(action: {
                //self.disclosureGroups.append(false)
            }, label: {
                Image(systemName: "plus.circle")
            }))
            //MARK: Hier endet der Test
            
            .navigationTitle(kategorieName)
        }
    }
    /*func addItem(context: ModelContext) {
     let newItem = EinkaufModel(name: "", anzahl: 0)
     context.insert(newItem)
     listenArray.arrays.append(newItem.name)
     }*/
}

struct EinkaufItemRowView: View {
    
    @State private var isDone: Bool = false
    @State private var anzahlObjekt: Int = 3
    @State private var showSheet: Bool = false
    @Binding var listenName: String
    let testName = "Neuer Artikel"
    
    @ObservedObject var listenArray: ListenArray
    
    var body: some View {
        HStack {
            Image(systemName: isDone ? "checkmark.circle.fill" : "checkmark.circle")
                .foregroundStyle(isDone ? .green : .primary)
                .onTapGesture {
                    isDone.toggle()
                }
            
            if listenName.isEmpty {
                TextField(testName, text: $listenName)
                    .strikethrough(isDone ? true : false)
                    .foregroundStyle(Color.gray.opacity(0.5))
            } else {
                TextField(listenName, text: $listenName)
                    .strikethrough(isDone ? true : false)
                    .foregroundStyle(isDone ? .gray : .primary)
            }
            
            Spacer()
            
            Button(action: { showSheet = true } ) {
                Text("\(anzahlObjekt)x")
            }
            /*TextField("\(anzahlObjekt)", value: $anzahlObjekt, formatter: NumberFormatter())*/
        }
        .sheet(isPresented: $showSheet) {
            ItemAnzahl(anzahlObjekt: $anzahlObjekt, listenName: listenName)
                .presentationDetents([.fraction(0.3)])
            }
    }
}

struct ItemAnzahl: View {
    
    @Binding var anzahlObjekt: Int
    
    let listenName: String
    
    var body: some View {
        NavigationStack {
            Picker("", selection: $anzahlObjekt) {
                ForEach(0..<101) { zahl in
                    Text("\(zahl)")
                        .foregroundStyle(.primary)
                }
            }
            .pickerStyle(.inline)
            .navigationTitle("Anzahl für \(listenName)")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

/*struct ItemRowView3: View {
 
 @Binding var isDone: Bool
 
 var body: some View {
 DisclosureGroup("Obst") {
 HStack {
 Button {
 isDone.toggle()
 } label: {
 Image(systemName: isDone ? "checkmark.circle.fill" : "checkmark.circle")
 }
 Text("🍎 Apfel")
 Spacer()
 Text("2x")
 }
 HStack {
 Image(systemName: "checkmark.circle")
 Text("🍐 Birne")
 Spacer()
 Text("5x")
 }
 }
 
 HStack {
 Button {
 isDone.toggle()
 } label: {
 Image(systemName: isDone ? "checkmark.circle.fill" : "checkmark.circle")
 }
 Text("⚡️ Flying Power ")
 Spacer()
 Text("24x")
 }
 }
 }*/

/*#Preview {
 Einkaufsliste(navTitle: "Navigationtitle", accentColor: .constant(Color.white), backgroundColor: .constant(Color.blue))
 }*/


/*struct EinkaufsListView: View {
 
 let kategorieNamen: String
 let anzahlKategorien: Int
 
 var body: some View {
 ZStack() {
 RoundedRectangle(cornerRadius: 15)
 .stroke()
 
 HStack {
 Image(systemName: "apple.logo")
 .padding(.horizontal)
 
 Spacer()
 
 Text(item.title)
 
 Spacer()
 
 ZStack {
 RoundedRectangle(cornerRadius: 10)
 .stroke()
 .frame(width: 40, height: 40)
 Text("\(anzahl)")
 }
 
 Image(systemName: "arrow.right")
 .padding()
 }
 }
 .font(.title2)
 .fontWeight(.bold)
 .frame(width: 350, height: 60)
 .background(Color.gray.opacity(0.5).cornerRadius(15))
 .padding(.top)
 }
 }*/


/*func addNewTestArray() {
 let newArray = ListenArray(kategorie: [newListenArrayKategorien], arrays: [], anzahl: 0, isDone: [newListenArrayKategorien : false])
 //let newArray = ListenArraysss(kategorien: [newListenArrayKategorien], arrays: [])
 context.insert(newArray)
 newListenArrayKategorien = ""
 }*/

//}
//
//struct EinkaufItemRowView2: View {
//    
//    @State private var isDone: Bool = false
//    @State private var anzahlObjekt: Int = 0
//    @Binding var listenName: String
//    let testName = "Neuer Artikel"
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
//            if listenName.isEmpty {
//                TextField(testName, text: $listenName)
//                    .strikethrough(isDone ? true : false)
//                    .font(.title2)
//                    .foregroundStyle(Color.gray.opacity(0.5))
//            } else {
//                TextField(listenName, text: $listenName)
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
//                    guard anzahlObjekt >= 1 else { return }
//                    anzahlObjekt -= 1
//                }
//            
//            Image(systemName: "plus.circle")
//                .resizable()
//                .foregroundStyle(.green)
//                .frame(width: 30, height: 30)
//                .onTapGesture {
//                    anzahlObjekt += 1
//                }
//            
//            Text("\(anzahlObjekt)")
//                .frame(width: 40)
//                .padding(.horizontal, 5)
//                .font(.title2)
//                .bold()
//            
//        }
//    }
//}

struct AddKategorie: View {
    
    @Environment(\.modelContext) var context
    @State private var textFieldText: String = ""
    @State private var color: Color = .red
    @State private var gruppe: Gruppe = .produktgruppe
    @Binding var listenArray: [ListenArray]
    @Binding var showSheet: Bool
    
    var body: some View {
        NavigationStack {
            Spacer()
            HStack {
                VStack {
                    Section("Name") {
                        
                        TextField("Füge eine neue Produktgruppe oder Supermarkt hinzu", text: $textFieldText)
                            .frame(width: 250, height: 50)
                            .padding(.horizontal)
                            .background(Color.gray.opacity(0.3).cornerRadius(10))
                            .padding(.horizontal)
                    }
                    .padding(.top, 5)
                    
                    Picker("Gruppe:", selection: $gruppe) {
                        ForEach(Gruppe.allCases, id: \.self) { gruppe in
                            Text(gruppe.gruppenName())
                        }
                    }
                    .pickerStyle(.inline)
                }
            }
            .padding(.bottom, 20)
            
            Spacer()
            
            Button(action: {
                let newKategorie = ListenArray(kategorie: textFieldText, arrays: [], gruppe: gruppe)
                listenArray.append(newKategorie)
                showSheet = false
            }, label: {
                AddItemButton(title: "Kategorie hinzufügen")
            })
            .padding()
            .navigationTitle("Neue Kategorie")
        }
    }
}

#Preview {
    Einkaufsliste(accentColor: .constant(.red), backgroundColor: .constant(.green), navTitle: "Test", listInfo: ListInfo(listName: "Listenname", backgroundColor: .tuerkis, accentColor: .black))
}
