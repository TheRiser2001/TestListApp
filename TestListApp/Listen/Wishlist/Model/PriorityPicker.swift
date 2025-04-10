//
//  PriorityPicker.swift
//  TestListApp
//
//  Created by Michael Ilic on 10.04.25.
//

import SwiftUI

struct PriorityPicker: View {
    
    @Namespace private var ns
    @Binding var prioPicker: Priority
    
    var body: some View {
        
        Picker("", selection: $prioPicker) {
            ForEach(Priority.allCases, id: \.self) { prio in
                Text(prio.asString)
            }
        }
        .pickerStyle(.segmented)
        .background {
            
            HStack(spacing: 0) {
                ForEach(Priority.allCases, id: \.self) { prio in
                    Color.clear
                        .matchedGeometryEffect(id: prio, in: ns, isSource: true)
                }
            }
        }
        .overlay {
            ZStack {
                prioPicker.color
                Text(prioPicker.asString)
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
            }
            .matchedGeometryEffect(id: prioPicker, in: ns, isSource: false)
            .clipShape(RoundedRectangle(cornerRadius: 7))
            .animation(.spring(duration: 0.28), value: prioPicker)
        }
    }
}
