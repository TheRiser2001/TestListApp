//
//  DateIcon.swift
//  TestListApp
//
//  Created by Michael Ilic on 30.05.24.
//

import SwiftUI

struct DateIcon: View {
    
    @State private var date = Date()
    var monat: String
    
    var body: some View {
        ZStack {
            if monat == "September" || monat == "November" || monat == "Dezember" {
                RoundedRectangle(cornerRadius: 25.0)
                    .stroke()
                    .frame(width: 180, height: 50)
                
                HStack {
                    Image(systemName: "calendar")
                    Text(monat)
                    Image(systemName: "arrow.down.square")
                }
            } else {
                RoundedRectangle(cornerRadius: 25.0)
                    .stroke()
                    .frame(width: 150, height: 50)
                
                HStack {
                    Image(systemName: "calendar")
                    Text(monat)
                    Image(systemName: "arrow.down.square")
                }
            }
        }
    }
}

#Preview {
    DateIcon(monat: "September")
}
