//
//  RezepteView.swift
//  TestListApp
//
//  Created by Michael Ilic on 26.03.24.
//
/* 
MARK: Erklärung extension PhotosPickerItem:
 1) Es wird eine func namens convert() erstellt, welche ein Image zurückgibt. async bedeutet, dass der restliche Code denooch ausgeführt wird solange die Funktion läuft.
 2) if let data = try await self.loadTransferable(type: Data.self) -> Hier wird versucht, asynchron Daten vom PhotosPickerItem zu laden. Durch die Funktion .loadTransferable wird das probiert und das Ergebnis wird in "data" gespeichert.
 3) if let uiImage = UIImage(data:data) -> Danach wird mit diesen gespeichert daten probiert ein UIImage zu erstellen und es unter uiImage abzuspeichern.
 4) Zum Schluss wird das alles in ein normales Image returned.
 5) Das return Image(systemName: "xmark.octagon") wird nur beim Fehler aufgerufen, genauso wie der catch-Block.
*/
import SwiftUI

struct RezepteView: View {
    
    @State private var rezepturen: [Rezeptur] = [
        Rezeptur(name: "Pizza", tageszeit: .fruehstueck, kcal: 10, kohlenhydrate: 100, proteine: 100, fette: 100),
        Rezeptur(name: "Pasta", tageszeit: .mittagessen, kcal: 200, kohlenhydrate: 20, proteine: 2, fette: 1000)
    ]
    @State private var showAddSheet: Bool = false
    @State private var selectedImage: Image?
    
    let listInfo: ListInfo
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(Tageszeit.allCases, id: \.self) { tageszeit in
                    Section(tageszeit.asString) {
                        ForEach(rezepturen.indices.filter { rezepturen[$0].tageszeit == tageszeit } , id: \.self) { index in
                            let rezept = rezepturen[index]
                            NavigationLink {
                                RezepteDetailView(selectedImage: $selectedImage, rezept: rezept, selectedTageszeit: $rezepturen[index].tageszeit)
                            } label: {
                                RezeptRowView(selectedImage: selectedImage, rezept: rezept)
                            }
                        }
                    }
                }
            }
            .listStyle(.grouped)
            .sheet(isPresented: $showAddSheet, content: {
                AddRezeptView()
            })
            
            .navigationTitle("Rezepte")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        //Hier kommt Code hin für Filterangaben für Tageszeiten.
                    }) {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        showAddSheet = true
                    }, label: {
                        Image(systemName: "plus.circle")
                    })
                }
            }
            
            .toolbarBackground(listInfo.backgroundColor.opacity(0.6), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}

struct RezeptRowView: View {
    
    let selectedImage: Image?
    let rezept: Rezeptur
    
    var body: some View {
            HStack {
                if let selectedImage {
                    selectedImage
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 75)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 75)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(width: 100, height: 75)
//                    .clipShape(RoundedRectangle(cornerRadius: 10))
//                    .onTapGesture {
//                        showImageChange = true
//                    }
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(rezept.name)
                        .font(.title2)
                        .bold()
                        .padding(.bottom, 5)
                    
                    let columns = [GridItem(alignment: .leading),
                                GridItem(alignment: .leading)]
                    
                    LazyVGrid(columns: columns) {
                        Text("kcal: \(rezept.kcal)g")
                        Text("Protein: \(rezept.proteine)g")
                    }
                    LazyVGrid(columns: columns) {
                        Text("KH: \(rezept.kohlenhydrate)g")
                        Text("Fett: \(rezept.fette)g")
                    }
                }
                .padding(.leading)
            }
//            .blur(radius: showImageChange ? 20 : 0)
    }
}

struct ChangeImageView: View {
    
    var body: some View {
        Text("Hi")
    }
}

struct AddRezeptView: View {
    var body: some View {
        Text("Hier wird eine UI für das hinzufügen kommen")
    }
}

#Preview {
    RezepteView(listInfo: ListInfo(listName: "", backgroundColor: .blue, accentColor: .white))
}
