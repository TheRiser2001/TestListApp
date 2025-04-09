//
//  InstructionPickerView.swift
//  TestListApp
//
//  Created by Michael Ilic on 03.04.25.
//

import SwiftUI

struct InstructionPickerView: View {
    
    @State private var editInstruction = false
    @State private var textFieldText: String = "test"
    
    @ObservedObject var recipe: Recipe
    
    var body: some View {
        if recipe.instructions.isEmpty {
            VStack {
                ContentUnavailableView("Test", systemImage: "star", description: Text("Füge deinen ersten Schritt deiner Mahlzeit hinzu"))
                Button("Anleitung hinzufügen") {
                    withAnimation {
                        let instruction = Instruction(step: "Neue Anleitung")
                        recipe.instructions.append(instruction)
                        editInstruction = false
                    }
                }
            }
        } else {
            List {
                Section {
                    ForEach($recipe.instructions, id: \.id) { instruction in
                        if editInstruction {
                            HStack {
                                InstructionDetail(instruction: instruction)

                            }
                        } else {
                            HStack {
                                Text("\(instruction.step.wrappedValue)")
                            }
                        }
                    }
                    Button("Neuer Schritt") {
                        let newInstruction = Instruction(step: "Nummer 1")
                        recipe.instructions.append(newInstruction)
                    }
                } header: {
                    HStack {
                        Text("\(recipe.instructions.count) Schritte")
                        Spacer()
                        Text(editInstruction ? "Done" : "Bearbeiten")
                            .font(.caption)
                            .onTapGesture {
                                withAnimation(.spring) {
                                    editInstruction.toggle()
                                }
                            }
                    }
                    .padding(.horizontal, -10)
                }
            }
            .listStyle(.insetGrouped)
        }
    }
}

struct InstructionDetail: View {
    
    @Binding var instruction: Instruction
    
    var body: some View {
        Image(systemName: "line.3.horizontal")
        Text(instruction.step)
        Spacer()
        Button {
            withAnimation {
                //                instructions.remove(atOffsets: [instructions.firstIndex(of: instruction)!])
            }
        } label: {
            Image(systemName: "minus.circle")
                .foregroundStyle(.red)
        }
    }
}

//#Preview {
//    InstructionPickerView()
//}
