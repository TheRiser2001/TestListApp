//
//  RezepteDetailView.swift
//  TestListApp
//
//  Created by Michael Ilic on 24.04.24.
//
// MARK: Wenn ich die Tageszeit von @State nehme, funktioniert es. Wenn ich die Tageszeit von "rezept" nehme, laggt es etwas und funktioniert nur mit Verzögerung.

/*
MARK: Erklärung extension PhotosPickerItem:
 1) Es wird eine func namens convert() erstellt, welche ein Image zurückgibt. async bedeutet, dass der restliche Code denooch ausgeführt wird solange die Funktion läuft.
 2) if let data = try await self.loadTransferable(type: Data.self) -> Hier wird versucht, asynchron Daten vom PhotosPickerItem zu laden. Durch die Funktion .loadTransferable wird das probiert und das Ergebnis wird in "data" gespeichert.
 3) if let uiImage = UIImage(data:data) -> Danach wird mit diesen gespeichert daten probiert ein UIImage zu erstellen und es unter uiImage abzuspeichern.
 4) Zum Schluss wird das alles in ein normales Image returned.
 5) Das return Image(systemName: "xmark.octagon") wird nur beim Fehler aufgerufen, genauso wie der catch-Block.
*/

import SwiftUI
import PhotosUI

extension PhotosPickerItem {
    @MainActor
    func convert() async -> Image {
        do {
            if let data = try await self.loadTransferable(type: Data.self) {
                if let uiImage = UIImage(data: data) {
                    return Image(uiImage: uiImage)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return Image(systemName: "xmark.octagon")
    }
}

struct RezepteDetailView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var showTageszeitPicker: Bool = false
    @State private var showErnährungPicker: Bool = false
    @State private var deleteRezeptAlert: Bool = false
    
    @State private var showImageDetail: Bool = false
    @State private var changeImageMenu: Bool = false

    @State private var image: PhotosPickerItem?
    
    @Binding var rezepturen: [Rezeptur]
    @Binding var rezept: Rezeptur
    
    var body: some View {
//        ZStack {
            NavigationStack {
                ScrollView {
                    VStack {
                        HStack {
                            VStack {
                                if let selectedImage = rezept.selectedImage {
                                    selectedImage
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(maxWidth: .infinity)
                                        .onTapGesture {
                                            changeImageMenu = true
                                        }
                                } else {
                                    Image(systemName: "photo")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 250)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .onTapGesture {
                                            changeImageMenu = true
                                        }
                                }
                                //MARK: Das ist ein Testbild, damit nicht der "else" case ausgeführt wird
                                //                            Image(.seitlichTest)
                                //                                .resizable()
                                //                                .aspectRatio(contentMode: .fill)
                                //                                .frame(maxWidth: .infinity)
                                //                                .frame(height: 250)
                                //                                .padding(.vertical)
                                //                                .onTapGesture {
                                //                                    changeImageMenu = true
                                //                                }
                                
                                HStack(spacing: 30) {
                                    WerteView(image: "flame", wert: rezept.kcal, einheit: "kcal")
                                    WerteView(image: "dumbbell", wert: rezept.proteine, einheit: "Protein")
                                    WerteView(image: "questionmark", wert: rezept.kohlenhydrate, einheit: "Carbs")
                                    WerteView(image: "questionmark", wert: rezept.fette, einheit: "Fett")
                                }
                                .padding(.top)
                            }
                        }
                        .onChange(of: image, { _, newImage in
                            if let newImage {
                                Task {
                                    rezept.selectedImage = await newImage.convert()
                                }
                            }
                        })
                        
                        // Wegen der Form wird nichts angezeigt darunter
//                        Form {
                            Section("Informationen") {
                                HStack {
                                    Text("Tageszeit:")
                                    Spacer()
                                    Text(rezept.tageszeit.asString)
                                    Image(systemName: "arrow.up.arrow.down.circle")
                                }
                                .onTapGesture {
                                    withAnimation(.easeInOut) {
                                        showErnährungPicker = false
                                        showTageszeitPicker.toggle()
                                    }
                                }
                                
                                if showTageszeitPicker {
                                    Picker("", selection: $rezept.tageszeit) {
                                        ForEach(Tageszeit.allCases, id: \.self) { tag in
                                            Text(tag.asString)
                                        }
                                    }
                                    .pickerStyle(.wheel)
                                    .frame(height: 150)
                                }
                                
                                HStack {
                                    Text("Ernährung:")
                                    Spacer()
                                    Text(rezept.ernaehrung.asString)
                                    Image(systemName: "arrow.up.arrow.down.circle")
                                }
                                .onTapGesture {
                                    withAnimation(.easeInOut) {
                                        showTageszeitPicker = false
                                        showErnährungPicker.toggle()
                                    }
                                }
                                
                                if showErnährungPicker {
                                    Picker("", selection: $rezept.ernaehrung) {
                                        ForEach(Ernährung.allCases, id: \.self) { art in
                                            Text(art.asString)
                                        }
                                    }
                                    .pickerStyle(.wheel)
                                    .frame(height: 150)
                                }
                            }
                            
                            Section("Anleitung") {
                                TextEditor(text: $rezept.anleitung)
                                    .frame(height: 260)
                            }
                            
                            Button("Rezept löschen") {
                                deleteRezeptAlert.toggle()
                            }
                            .foregroundStyle(.red)
                            .frame(maxWidth: .infinity)
                            .frame(height: 30)
//                        }
                    } 
                }
                .background(Color(.systemGray6))
                .navigationTitle(rezept.name)
                
                .alert("Rezept löschen?", isPresented: $deleteRezeptAlert) {
                    Button("Ja", role: .destructive) {
                        if let index = rezepturen.firstIndex(where: { $0.id == rezept.id }) {
                            rezepturen.remove(at: index)
                            dismiss()
                        }
                    }
                } message: {
                    Text("Bist du sicher, dass das Rezept endgültig gelöscht werden soll? Du kannst es danach nicht wiederherstellen")
                }
                
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        ShareLink(item: "Anleitung für \(rezept.name)")
                    }
                }
            }
            
            .sheet(isPresented: $changeImageMenu) {
                ChangeImageMenu(image: $image, changeImageMenu: $changeImageMenu, rezept: $rezept)
                    .presentationDetents([.fraction(0.2)])
            }
//        }
    }
}

struct ChangeImageMenu: View {
    
    @Binding var image: PhotosPickerItem?
    @Binding var changeImageMenu: Bool
    @Binding var rezept: Rezeptur
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    PhotosPicker(selection: $image, matching: .images) {
                        HStack {
                            Text("Bild auswählen")
                            Spacer()
                            Image(systemName: "photo")
                        }
                    }
                    
                    Button(role: .destructive) {
                        //Code für das löschen vom Bild
                    } label: {
                        HStack {
                            Text("Bild löschen")
                            Spacer()
                            Image(systemName: "trash")
                        }
                    }
                }
            }
            .background(Color(.systemGray6))
            .navigationTitle("Bild bearbeiten")
            
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { changeImageMenu = false }, label: {
                        XDismissButton()
                    })
                }
            }
        }
    }
}

struct WerteView: View {
    
    let image: String
    let wert: Int
    let einheit: String
    
    var body: some View {
        VStack {
            Image(systemName: image)
                .frame(height: 20)
            Text("\(wert)")
            Text(einheit)
        }
    }
}

#Preview {
    RezepteDetailView(rezepturen: .constant([]), rezept: .constant(Rezeptur(name: "Pizza", selectedImage: Image("SeitlichTest"), tageszeit: .mittagessen, ernaehrung: .ketogen, kcal: 200, kohlenhydrate: 250, proteine: 200, fette: 200)))
}

//#Preview("DetailPictureView") {
//    DetailPictureView(rezept: Rezeptur(name: "", tageszeit: .abendessen, ernaehrung: .definitionsphase, kcal: 22, kohlenhydrate: 2, proteine: 2, fette: 2), showImageDetail: .constant(true))
//}
