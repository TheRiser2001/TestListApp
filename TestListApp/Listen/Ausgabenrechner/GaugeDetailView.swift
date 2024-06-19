//
//  GaugeDetailView.swift
//  TestListApp
//
//  Created by Michael Ilic on 28.05.24.
//

import SwiftUI

struct GaugeModel: Identifiable {
    public var id = UUID()
    var color: Color
    var size: Double
    
    public init(color: Color, size: Double) {
        self.color = color
        self.size = size
    }
}

struct GaugeElement: View {
var section: GaugeModel
var startAngle: Double
var trim: ClosedRange<CGFloat>
var lineCap: CGLineCap = .butt                             // Für die Abrundung zwischen den Farben

var body: some View {
    GeometryReader { geometry in
        let lineWidth = geometry.size.width / 10            //Die Dicke des Kreises
        
        section.color                               //Hier wird von der GaugeViewSection die Farbe bestimmt.
            .mask(Circle()                          //Es wird eine Art maske über den Kreis "gelegt"
                    .trim(from: trim.lowerBound, to: trim.upperBound)   //Kein ganzer Kreis, abstand dazwischen
                    .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: lineCap))  //Teil der Formatierung des Kreises
                    .rotationEffect(Angle(degrees: startAngle))         //Lücke nach unten platziert
                    .padding(lineWidth/2)           //Padding von der mitte weg
            )
    }
}
}


struct GaugeDetailView: View {
    var angle: Double
    var sections: [GaugeModel]
//    var value: Double
    var valueDescription: String?
    var gaugeDescription: String?
    
    public init(angle: Double, sections: [GaugeModel], /*value: Double,*/ valueDescription: String? = nil, gaugeDescription: String? = nil) {
        self.angle = angle
        self.sections = sections
//        self.value = value
        self.valueDescription = valueDescription
        self.gaugeDescription = gaugeDescription
    }
    
    public var body: some View {
        // 90 to start in south orientation, then add offset to keep gauge symetric
        let startAngle = 90 + (360.0-angle) / 2.0
        
        ZStack {
            ForEach(sections) { section in
                // Find index of current section to sum up already covered areas in percent
                if let index = sections.firstIndex(where: {$0.id == section.id}) {
                    let alreadyCovered = sections[0..<index].reduce(0) { $0 + $1.size}
                    
                    // 0.001 is a small offset to fill a gap
                    let sectionSize = section.size * (angle / 360.0)// + 0.001
                    let sectionStartAngle = startAngle + alreadyCovered * angle
                    
                    GaugeElement(section: section, startAngle: sectionStartAngle, trim:  0...CGFloat(sectionSize))
                    
                    // Add round caps at start and end
                    if index == 0 || index == sections.count - 1{
                        let capSize: CGFloat = 0.001
                        let startAngle: Double = index == 0 ? sectionStartAngle : startAngle + angle
                        
                        GaugeElement(section: section,
                                     startAngle: startAngle,
                                     trim: 0...capSize,
                                     lineCap: .round)
                    }
                }
            }
            
            //MARK: Dieses .overlay ist für die Beschreibung unten
            .overlay(
                VStack{
                    if let valueDescription = valueDescription {
                        Text(valueDescription)
                            .font(.title)
                    }
                    if let gaugeDescription = gaugeDescription {
                        Text(gaugeDescription)
                            .font(.caption)
                    }
                }, alignment: .bottom)
        }
    }
}

#Preview {
    let angle: Double = 260.0
    let sections: [GaugeModel] = [GaugeModel(color: .green, size: 0.1),
                                          GaugeModel(color: .yellow, size: 0.1),
                                          GaugeModel(color: .orange, size: 0.1),
                                          GaugeModel(color: .red, size: 0.1),
                                          GaugeModel(color: .purple, size: 0.2),
                                          GaugeModel(color: .blue, size: 0.4)]

    let valueDescription = "\(Int(0.35 * 100)) %"
    let gaugeDescription = "My SwiftUI Gauge"

    return GaugeDetailView(angle: angle, sections: sections, valueDescription: valueDescription, gaugeDescription: gaugeDescription)
}

