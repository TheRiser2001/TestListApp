//
//  EreignisView.swift
//  TestListApp
//
//  Created by Michael Ilic on 09.07.24.
//

import Foundation
import SwiftUI

struct EreignisView: View {
    
    var day: Date
    var ereignis: [Ereignis]
    var filteredEreignis: [Ereignis] = []
    
    init(day: Date, ereignis: [Ereignis]) {
        self.day = day
        self.ereignis = ereignis
        self.filteredEreignis = ereignis.filter{ $0.startZeit.startOfDay == day.startOfDay }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Ereignisse")
            List(filteredEreignis) { ereignis in
                HStack {
                    Circle()
                        .frame(width: 20)
                        .foregroundStyle(ereignis.color)
                    VStack {
                        Text(ereignis.ereignis)
                        Text("\(ereignis.startZeit.formatted(date: .omitted, time: .shortened)) bis \(ereignis.endZeit.formatted(date: .omitted, time: .shortened))")
                    }
                }
            }
            .listStyle(.plain)
        }
    }
}

#Preview {
    EreignisView(day: Date.now, ereignis: [Ereignis(startZeit: .now, endZeit: .now, ereignis: "Test", color: .red)])
}
