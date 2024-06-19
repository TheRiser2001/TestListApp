import SwiftUI

struct ColorPaletteView: View {
    let colors: [Color] = [.red, .blue, .green, .yellow, .orange, .purple, .pink, .gray, .white, .cyan, .bubblegum] // Hier können Sie Ihre Farben hinzufügen
    let colorsPerRow = 4 // Anzahl der Farben pro Reihe
    @State private var selectedColor: Color?
    
    var body: some View {
        VStack {
            Text("Selected Color: \(selectedColor == nil ? "None" : selectedColor!.description)")
                .padding()
            
            VStack {
                ForEach(0..<colors.count/colorsPerRow + 1, id: \.self) { rowIndex in
                    HStack {
                        ForEach(0..<min(colorsPerRow, colors.count - rowIndex*colorsPerRow), id: \.self) { colIndex in
                            let index = rowIndex * colorsPerRow + colIndex
                            Circle()
                                .fill(colors[index])
                                .overlay(
                                    Circle()
                                        .stroke(selectedColor == colors[index] ? Color.black : Color.clear, lineWidth: 3)
                                )
                                .frame(width: 30, height: 30)
                                .onTapGesture {
                                    self.selectedColor = colors[index]
                                }
                        }
                    }
                }
            }
        }
        .padding()
    }
}


struct ColorPaletteView_Previews: PreviewProvider {
    static var previews: some View {
        ColorPaletteView()
    }
}

