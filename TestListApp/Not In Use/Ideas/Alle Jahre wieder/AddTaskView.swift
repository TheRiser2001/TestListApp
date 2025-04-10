//
//  AddTaskView.swift
//  TaskPlanner
//
//  Created by Michael Ilic on 10.07.24.
//

import SwiftUI

struct AddTaskView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var taskName: String = ""
    @State private var taskDescription: String = ""
    @State private var taskDate: Date = .init()
    @State private var taskCategory: Category = .bug
    
    // - Animations Properties
    @State private var animateColor: Color = Category.bug.color
    @State private var animate: Bool = false
    
    @Binding var tasks: [Aufgabe]
    
    var body: some View  {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 12) {
                Button { dismiss() } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(.white)
                }
                
                Text("Neue Aufgabe erstellen")
                    .foregroundStyle(.white)
                    .font(.title2)
                
                TitleView("Name")
                
                TextField("Mach ein neues Video", text: $taskName)
                    .foregroundStyle(.white)
                
                Rectangle()
                    .fill(.white.opacity(0.7))
                    .frame(height: 1)
                
                TitleView("Datum")
                
                HStack(alignment: .bottom, spacing: 12) {
                    HStack {
                        Text(taskDate.format("EEEE dd, MMMM"))
                            .foregroundStyle(.white)
                        Image(systemName: "calendar")
                            .foregroundStyle(.white)
                            .overlay {
                                DatePicker("", selection: $taskDate, displayedComponents: .date)
                                    .blendMode(.destinationOver)
                            }
                    }
                    .offset(y: -5)
                    .overlay {
                        Rectangle()
                            .fill(.white.opacity(0.7))
                            .frame(height: 1)
                            .offset(y: 15)
                    }
                    .padding(.trailing)
                    
                    HStack {
                        Text(taskDate.format("HH:mm"))
                            .foregroundStyle(.white)
                        Image(systemName: "clock")
                            .foregroundStyle(.white)
                            .overlay {
                                DatePicker("", selection: $taskDate, displayedComponents: .hourAndMinute)
                                    .blendMode(.destinationOver)
                            }
                    }
                    .offset(y: -5)
                    .overlay {
                        Rectangle()
                            .fill(.white.opacity(0.7))
                            .frame(height: 1)
                            .offset(y: 15)
                    }
                }
                .padding(.bottom, 15)
            }
            .hAlign(.leading)
            .padding(15)
            .background {
                ZStack {
                    taskCategory.color
                    
                    GeometryReader {
                        let size = $0.size
                        Rectangle()
                            .fill(animateColor)
                            .mask {
                                Circle()
                            }
                            .frame(width: animate ? size.width * 2 : 0, height: animate ? size.height * 2 : 0)
                            .offset(animate ? CGSize(width: -size.width / 2, height: -size.height / 2) : size)
                    }
                    .clipped()
                }
                .ignoresSafeArea()
            }
            
            VStack(alignment: .leading, spacing: 10) {
                TitleView("Beschreibung", .gray)
                
                TextField("Füge eine Beschreibung hinzu", text: $taskDescription)
                    .padding(.top, 12)
                Rectangle()
                    .fill(.gray)
                    .frame(height: 1)
                
                TitleView("Kategorie", .gray)
                    .padding(.top, 15)
                
                LazyVGrid(columns: Array(repeating: GridItem(), count: 3)) {
                    ForEach(Category.allCases, id: \.self) { category in
                        Text(category.rawValue.uppercased())
                            .font(.caption)
                            .hAlign(.center)
                            .padding(.vertical, 5)
                            .background {
                                RoundedRectangle(cornerRadius: 5, style: .continuous)
                                    .fill(category.color.opacity(0.3))
                            }
                            .foregroundStyle(category.color)
                            .onTapGesture {
                                guard !animate else { return }
                                animateColor = category.color
                                withAnimation(.interactiveSpring(response: 0.7, dampingFraction: 1, blendDuration: 1)) {
                                    animate = true
                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                                    animate = false
                                    taskCategory = category
                                }
                            }
                    }
                }
                Spacer()
                Button {
                    let newTask = Aufgabe(date: taskDate, taskName: taskName, taskDescription: taskDescription, isCompleted: false, taskCategory: taskCategory)
                    tasks.append(newTask)
                    dismiss()
                } label: {
                    Text("Neue Aufgabe hinzufügen")
                        .foregroundStyle(.white)
                }
                .padding()
                .hAlign(.center)
                .background {
                    Capsule()
                        .fill(animateColor.gradient)
                }
                .disabled(taskName == "" ? true : false)
                .opacity(taskName == "" ? 0.6 : 1)
            }
            .padding(15)
        }
        .vAlign(.top)
    }
    
    @ViewBuilder
    private func TitleView(_ value: String, _ color: Color = .white.opacity(0.7)) -> some View {
        Text(value)
            .font(.caption)
            .foregroundStyle(color)
    }
}

#Preview {
    AddTaskView(tasks: .constant([Aufgabe(date: .now, taskName: "Test", taskDescription: "Test", isCompleted: false, taskCategory: .bug)]))
}
