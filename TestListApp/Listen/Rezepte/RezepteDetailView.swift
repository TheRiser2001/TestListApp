//
//  RezepteDetailView.swift
//  TestListApp
//
//  Created by Michael Ilic on 24.04.24.
//
// MARK: Wenn ich die Tageszeit von @State nehme, funktioniert es. Wenn ich die Tageszeit von "rezept" nehme, laggt es etwas und funktioniert nur mit Verzögerung.

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
    
    @State private var anleitung: String = ""
    @State private var ernährungsarten: Ernährung = Ernährung.vegan
    @State private var tageszeit: Tageszeit = .abendessen
    @State private var showTageszeitPicker: Bool = false
    @State private var showErnährungPicker: Bool = false

    @State private var image: PhotosPickerItem?
    @Binding var selectedImage: Image?
    
    let rezept: Rezeptur
    
    @Binding var selectedTageszeit: Tageszeit
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    VStack {
                        if let selectedImage {
                            selectedImage
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 120, height: 90, alignment: .leading)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .padding(.leading)
                        } else {
                            Image(systemName: "photo")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 120, height: 90, alignment: .leading)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .padding(.leading)
                        }
                        PhotosPicker(selection: $image, matching: .images) {
                            Text("Bild auswählen")
                                .padding(.leading)
                        }
                    }
                    
                    Spacer()
                    
                    VStack {
                        let columns = [GridItem(.fixed(90), alignment: .leading),
                                       GridItem(.fixed(130) ,alignment: .leading)]
                        
                        LazyVGrid(columns: columns) {
                            Text("kcal: \(rezept.kcal)g")
                            Text("Protein: \(rezept.proteine)g")
                        }
                        LazyVGrid(columns: columns) {
                            Text("KH: \(rezept.kohlenhydrate)g")
                            Text("Fett: \(rezept.fette)g")
                        }
                    }
                    .padding(.bottom)
                }
                .onChange(of: image, { _, newImage in
                    if let newImage {
                        Task {
                            selectedImage = await newImage.convert()
                        }
                    }
                })
                
                Form {
                    Section("Informationen") {
                        HStack {
                            Text("Tageszeit:")
                            Spacer()
                            Text(tageszeit.asString)
                            Image(systemName: "arrow.up.arrow.down.circle")
                        }
                        .onTapGesture {
                            withAnimation(Animation.easeInOut) {
                                showErnährungPicker = false
                                showTageszeitPicker.toggle()
                            }
                        }
                        
                        if showTageszeitPicker {
                            Picker("", selection: $tageszeit) {
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
                            Text(ernährungsarten.asString)
                            Image(systemName: "arrow.up.arrow.down.circle")
                        }
                        .onTapGesture {
                            withAnimation(Animation.easeInOut) {
                                showTageszeitPicker = false
                                showErnährungPicker.toggle()
                            }
                        }
                        
                        if showErnährungPicker {
                            Picker("", selection: $ernährungsarten) {
                                ForEach(Ernährung.allCases, id: \.self) { art in
                                    Text(art.asString)
                                }
                            }
                            .pickerStyle(.wheel)
                            .frame(height: 150)
                        }
                    }
                    
                    Section("Anleitung") {
                        TextEditor(text: $anleitung)
                            .frame(height: 260)
                    }
                    
                    Button("Rezept löschen") {
                        
                    }
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity)
                    .frame(height: 30)
                }
            }
            .background(Color(.systemGray6))
            .navigationTitle(rezept.name)
            
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    ShareLink(item: "Anleitung für \(rezept.name)")
                }
            }
        }
    }
}

#Preview {
    RezepteDetailView(selectedImage: .constant(nil), rezept: Rezeptur(name: "Pizza", tageszeit: .mittagessen, kcal: 200, kohlenhydrate: 200, proteine: 200, fette: 200), selectedTageszeit: .constant(.abendessen))
}
