//
//  TestView.swift
//  TestListApp
//
//  Created by Michael Ilic on 25.05.24.
//

import SwiftUI

class AccountPerson: ObservableObject {
    let id = UUID()
    let name: String
    
    init(name: String) {
        self.name = name
    }
}

struct TestView: View {
    
    @State private var personen: [AccountPerson] = [
        AccountPerson(name: "Michi"),
        AccountPerson(name: "Tina")
        ]
    
    var body: some View {
        
//        NavigationStack {
        VStack {
                Text("Gesamtguthaben Haushalt")
                
                Gauge(value: 0.5) {
                    Text("2.500,50€")
                        .font(.title)
                        .bold()
                        .padding(4)
                }
                .padding(.horizontal)
                
                HStack {
                    Text("Accounts")
                        .font(.title)
                        .bold()
                        .padding()
                    Spacer()
                }
                
                ForEach(personen.indices, id:  \.self) { index in
                    VStack(alignment: .leading) {
                        Text(personen[index].name)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 30)
                        
                        NavigationLink {
                            DetailView(person: personen[index])
                        } label: {
                            RectangleSubview(person: personen[index])
                                .padding(.horizontal)
                                .padding(.bottom)
                        }
                    }
                }
                
                Button(action: {
                    let newPerson = AccountPerson(name: "Test")
                    personen.append(newPerson)
                }, label: {
                    Image(systemName: "plus.circle")
                    Text("Neue Person im Haushalt")
                })
                .foregroundStyle(.green)
            }
            Spacer()
//        }
    }
}

struct RectangleSubview: View {
    
    @State private var showSheet: Bool = false
    
    @ObservedObject var person: AccountPerson
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 25.0)
                .stroke()
                .tint(.black)
                .frame(height: 150)
                .background(Color.gray.opacity(0.2).cornerRadius(25))
            
            VStack {
                HStack {
                    Image(systemName: "eurosign.circle")
                        .resizable()
                        .frame(width: 25, height: 25)
                    Text("2.400€")
                        .font(.title2)
                    Spacer()
                    
                    Menu {
                        Button("Verschieben") {
                            
                        }
                        
                        Button("Person löschen", role: .destructive) {
                            
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                    }
                    .foregroundStyle(.primary)
                    
                }
                .foregroundStyle(.black)
                Text("Hier kommt noch irgendwas hin")
                    .foregroundStyle(.black)
                
                HStack {
                    Spacer()
                    
                    Group {
                        Button(action: {
                            showSheet.toggle()
                        }, label: {
                            Image(systemName: "plus.circle")
                            Text("Einnahme")
                        })
                        .padding()
                        .overlay {
                            RoundedRectangle(cornerRadius: 25.0)
                                .stroke()
                                .foregroundStyle(.green)
                        }
                    }
                    .tint(.green)
                    
                    Spacer()
                    
                    Group {
                        Button(action: {
                            
                        }, label: {
                            Image(systemName: "minus.circle")
                            Text("Ausgabe")
                        })
                        .padding()
                        .overlay {
                            RoundedRectangle(cornerRadius: 25.0)
                                .stroke()
                                .foregroundStyle(.red)
                        }
                    }
                    .tint(.red)
                    Spacer()
                }
            }
            .padding()
        }
        
        .sheet(isPresented: $showSheet, content: {
            EinnahmeSheet(person: person)
                .presentationDetents([.fraction(0.4)])
        })
    }
}

struct EinnahmeSheet: View {
    
    @ObservedObject var person: AccountPerson
    
    var body: some View {
        Text("Neue Einnahme für \(person.name) hinzufügen")
    }
}

struct DetailView: View {
    
    @State private var kostenTest: [Int] = [5, 8, 10]
    @State private var testmonat: String = "Monat"
    
    @ObservedObject var person: AccountPerson
    
    let angle: Double = 260.0
    let valueDescription = "\(Int(0.35 * 100)) %"
    let gaugeDescription = "My SwiftUI Gauge"
    
    let monate = ["Januar", "Februar", "März", "April", "Mai", "Juni", "Juli", "August", "September", "Oktober", "November", "Dezember"]
    
    var body: some View {
        
        VStack(alignment: .trailing) {
            Menu {
                ForEach(monate, id: \.self) { monat in
                    Button(monat) {
                        testmonat = monat
                    }
                }
            } label: {
                DateIcon(monat: testmonat)
                    .padding(.trailing)
            }
            
            let sections: [GaugeModel] = [GaugeModel(color: .red, size: 0.1),
                                                  GaugeModel(color: .green, size: 0.2),
                                                  GaugeModel(color: .blue, size: 0.3),
                                                  GaugeModel(color: .yellow, size: 0.4)]
//            let gesamtausgaben = kostenTest
            
            GaugeDetailView(angle: angle, sections: sections, valueDescription: valueDescription, gaugeDescription: gaugeDescription)
                .padding(.horizontal)
                .overlay {
                    VStack {
                        Text("Michi")
                            .font(.title)
                            .bold()
                        //MARK: Hier gibt es ein Problem mit dem Format
//                        Text("Gesamtausgaben: \(String(format: "%.2f", kostenTest.reduce(0, +)))€")
                        //MARK: Erster Parameter gibt den ersten Wert an mit dem die Rechenoperation gestartet wird. Der zweite Parameter gibt an, welche Rechenoperation durchgeführt wird.
                        Text("Gesamtausgaben: \(kostenTest.reduce(0, +))€")
                    }
                }
            
            Spacer()
            
//                VStack {
//                    HStack {
//                        DetailRectangleSubView(preis: .constant(50), color: .red, kategorie: "Fixkosten")
//                        DetailRectangleSubView(preis: .constant(100), color: .green, kategorie: "Abonnements")
//                        ForEach($kostenTest, id: \.self) { preis in
//                            DetailRectangleSubView(preis: preis, color: .red, kategorie: "Test")
//                        }
//                    }
//                    .padding(.horizontal)
//                    
//                    HStack {
//                        DetailRectangleSubView(preis: .constant(50), color: .blue, kategorie: "Auto")
//                        DetailRectangleSubView(preis: .constant(200) ,color: .yellow, kategorie: "Freundin")
//                    }
//                    .padding(.horizontal)
//                }
            LazyVGrid(columns: [GridItem(), GridItem()], content: {
                ForEach($kostenTest, id: \.self) { preis in
                    DetailRectangleSubView(preis: preis, color: .red, kategorie: "Test")
                }
            })
        }
    }
}

struct DetailRectangleSubView: View {
    
    @Binding var preis: Int
    let color: Color
    let kategorie: String
    
    var body: some View {
        
        NavigationLink {
            Text("Hi")
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .stroke()
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("\(preis)€")
                        Spacer()
                        Text("25%")
                    }
                    .padding(.top)
                    .padding(.horizontal)
                    Spacer()
                    
                    HStack {
                        Image(systemName: "circle.fill")
                            .foregroundStyle(color)
                            .padding(.leading)
                        
                        Text(kategorie)
                    }
                    .padding(.bottom)
                }
            }
            .foregroundStyle(.primary)
            .tint(.primary)
            .frame(maxWidth: .infinity)
            .frame(height: 100)
            .padding(.horizontal)
        }
    }
}

#Preview {
//    TestView()
    DetailView(person: AccountPerson(name: "Michi"))
}
