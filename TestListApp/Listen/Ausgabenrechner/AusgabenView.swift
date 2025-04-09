//
//  AusgabenView.swift
//  TestListApp
//
//  Created by Michael Ilic on 26.03.24.
//

import SwiftUI

struct AusgabenView: View {
    
    @State private var value = 75.0
    private let minValue = 0.0
    private let maxValue = 100.0
    
    let gradient = Gradient(colors: [.green, .yellow, .orange, .red])
    let listInfo: ListInfo
    
    var body: some View {
        NavigationStack {
            VStack {
                
                Group {
                    Text("Zur Verfügung stehen dir")
                        .font(.title)
                        .padding(.vertical)
                    Gauge(value: value, in: minValue...maxValue) {
                        Text("1250€")
                            .font(.title3)
                            .foregroundStyle(.green)
                    } currentValueLabel: {
                        HStack {
                            Text(value, format: .number)
                        }
                    } minimumValueLabel: {
                        Text(minValue, format: .number)
                    } maximumValueLabel: {
                        Text(maxValue, format: .number)
                    }
                    .tint(gradient)
                }
                .padding(.horizontal)
                
                Divider()
                
                GeometryReader { geometry in
                    HStack(alignment: .top) {
                        VStack {
                            Text("Einnahmen")
                                .bold()
                            HStack {
                                Text("+ 2500€")
                                    .foregroundStyle(.green)
                                Text("Gehalt")
                            }
                            HStack {
                                Text("+ 200€")
                                    .foregroundStyle(.green)
                                Text("Oma")
                            }
                            
                            Divider()
                            
                            Button {
                                
                            } label: {
                                Text("Einnahmen")
                                Image(systemName: "plus.circle")
                            }
                            
                            Divider()
                        }
                        
                        Divider()
                        
                        VStack {
                            Text("Ausgaben")
                                .bold()
                            HStack {
                                Text("- 800€")
                                    .foregroundStyle(.red)
                                Text("Miete")
                            }
                            
                            Divider()
                            
                            Button {
                                
                            } label: {
                                Text("Ausgaben")
                                Image(systemName: "minus.circle")
                            }
                            
                            Divider()
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.48)
                    }
                }
            }
        }
        .navigationTitle("Ausgabenrechner")
        .toolbarBackground(listInfo.backgroundColor.opacity(0.6), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}

//#Preview {
//    AusgabenView(listInfo: ListInfo(listName: "", systemName: "cart", backgroundColor: .blue, accentColor: .blue))
//}
