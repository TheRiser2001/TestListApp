//
//  KalendarView.swift
//  TestListApp
//
//  Created by Michael Ilic on 12.07.24.
//

import SwiftUI

struct KalendarView: View {
    @State private var currentDate: Date = .init()
    @State private var weekSlider: [[Date.WeekDay]] = []
    @State private var currentWeekIndex: Int = 1
    @State private var tasks: [Aufgabe] = beispielAufgaben.sorted(by: { $1.date > $0.date })

    @State private var createWeek: Bool = false
    @State private var createNewTask: Bool = false
    @State private var addTaskView: Bool = false
    
    @Namespace private var animation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HeaderView()
            
            ScrollView {
                VStack {
                    TasksView()
                }
                .hAlign(.center)
                .vAlign(.center)
            }
            .scrollIndicators(.hidden)
        }
        .vAlign(.top)
        .onAppear {
            if weekSlider.isEmpty {
                let currentWeek = Date().fetchWeek()
                
                if let firstDate = currentWeek.first?.date {
                    weekSlider.append(firstDate.createPreviousWeek())
                }
                
                weekSlider.append(currentWeek)
                
                if let lastDate = currentWeek.last?.date {
                    weekSlider.append(lastDate.createNextWeek())
                }
                
            }
        }
    }
    
    @ViewBuilder
    func HeaderView() -> some View {
        VStack(alignment: .leading, spacing: 6) {
            VStack(alignment: .leading) {
                HStack(spacing: 5) {
                    Text(currentDate.format("MMMM"))
                        .foregroundStyle(.blue)
                    
                    Text(currentDate.format("YYYY"))
                        .foregroundStyle(.gray)
                }
                .font(.title.bold())
                
                Text(currentDate.formatted(date: .complete, time: .omitted))
                    .font(.callout)
                    .fontWeight(.semibold)
                    .textScale(.secondary)
                    .foregroundStyle(.gray)
            }
            // - Week Slider
            TabView(selection: $currentWeekIndex) {
                ForEach(weekSlider.indices, id: \.self) { index in
                    let week = weekSlider[index]
                    WeekView(week)
                        .padding(.horizontal, 15)
                        .tag(index)
                }
            }
            .padding(.horizontal, -15)
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 90)
        }
        .hAlign(.leading)
        .padding(15)
        
        // - Add Button
        .overlay {
            Button {
                addTaskView.toggle()
            } label: {
                Image(systemName: "plus")
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .frame(width: 40, height: 40)
                    .background(.blue.shadow(.drop(color: .black.opacity(0.25), radius: 5)), in: .circle)
            }
            .hAlign(.trailing)
            .vAlign(.top)
            .padding(.top, 5)
            .padding()
        }
        
        // - Das ist für das scrollen der Wochen
        .onChange(of: currentWeekIndex, initial: false) { oldValue, newValue in
            /// Es werden immer nur die vorwoche und die darauffolgende woche erstellt. Mit der jetzigen Woche sind im Array somit 3 Felder belegt. Wenn man die woche ändert, zum beispiel nach vorne, dann wird hier die nächste woche erstellt und die früheste Woche gelöscht. Somit werden im array immer nur 3 plätze belegt sein
            if newValue == 0 || newValue == (weekSlider.count - 1) {
                createWeek = true
            }
        }
        
        // - AddTaskView
        .fullScreenCover(isPresented: $addTaskView) {
            AddTaskView(tasks: $tasks)
        }
    }
    
    // - Week View
    @ViewBuilder
    func WeekView(_ week: [Date.WeekDay]) -> some View {
        HStack(spacing: 0) {
            ForEach(week) { day in
                let colors = taskColor(for: day.date)
//                let taskIndex = tasks.firstIndex(where: { $0.id == day.id })
                VStack(spacing: 8) {
                    Text(day.date.format("E"))
                        .font(.callout)
                        .fontWeight(.medium)
                        .textScale(.secondary)
                        .foregroundStyle(.gray)
                    
                    Text(day.date.format("dd"))
                        .font(.callout)
                        .fontWeight(.bold)
                        .textScale(.secondary)
                        .foregroundStyle(isSameDate(day.date, currentDate) ? .white : .gray)
                        .frame(width: 35, height: 35)
                        .background {
                            if isSameDate(day.date, currentDate) {
                                Circle()
                                    .fill(.blue)
                                    .matchedGeometryEffect(id: "TABINDICATOR", in: animation)
                            }
                            
                            if !colors.isEmpty {
                                HStack(spacing: 2) {
                                        ForEach(colors, id: \.self) { color in
                                            Circle()
                                                .fill(color)
                                                .frame(width: 6, height: 6)
                                                .vAlign(.bottom)
                                                .offset(y: 12)
                                        }
                                }
                            }
                        }
                        .background(.white.shadow(.drop(radius: 1)), in: .circle)
                }
                .hAlign(.center)
                .contentShape(.rect)
                .onTapGesture {
                    // - Updating Current Date
                    withAnimation(.snappy) {
                        currentDate = day.date
                    }
                }
            }
        }
        .background {
            // - Hier kommt der GeometryReader hin für die nächsten wochen usw
            GeometryReader {
                let minX = $0.frame(in: .global).minX
                
                /// Hier wird der gesamte Kalender markiert. Hier wird eine Position bestimmt (minX), sobald dieser Wert 15 ist und createWeek = true wird eine neue Woche hinzugefügt. 15 weil wir für die WeekView() ein padding von 15 angegeben haben.
                Color.clear
                    .preference(key: OffSetKey.self, value: minX)
                    .onPreferenceChange(OffSetKey.self) { value in
                        if value.rounded() == 15 && createWeek {
                            wochenPagen()
                            createWeek = false
                        }
                    }
            }
        }
    }
    
    // - Tasks View
    @ViewBuilder
    func TasksView() -> some View {
        VStack(alignment: .leading, spacing: 35) {
            /// Die Verwendung von Bindungen ($tasks und $task) ist notwendig, um sicherzustellen, dass Änderungen an den einzelnen Aufgaben innerhalb des ForEach-Loops die ursprüngliche State-Variable tasks aktualisieren. Ohne die Dollarzeichen würden Änderungen keine Auswirkungen auf die State-Variable haben, was in den meisten Anwendungsfällen nicht das gewünschte Verhalten ist.
            let calendar = Calendar.current
            let filteredTasks = tasks.filter {
                calendar.isDate($0.date, inSameDayAs: currentDate)
            }
            let sortedTasks = filteredTasks.sorted(by: { $0.date < $1.date })
            
            ForEach(sortedTasks) { task in
                if let taskIndex = tasks.firstIndex(where: { $0.id == task.id }) {
                    TaskRowView(task: $tasks[taskIndex])
                        .background(alignment: .leading) {
                            /// Das erzeugt die schwarze Linie ganz links
                            if tasks.last?.id != task.id {
                                Rectangle()
                                    .frame(width: 1)
                                    .offset(x: 8)
                                    .padding(.bottom, -35)
                            }
                        }
                }
            }
        }
        .padding([.vertical, .leading], 15)
        .padding(.top, 15)
    }
    
    func wochenPagen() {
        /// Hier wird erstmal kontrolliert ob der currentWeekIndex auch innerhalb des weekSliders existiert
        if weekSlider.indices.contains(currentWeekIndex) {
            /// Hier wird überprüft, ob die aktuelle Woche des Arrays 0 ist. Wenn ja, wird eine Woche davor hinzugefügt (also auf den neuen 0ten platz) und die letzte Woche (also der letzte Punkt des Arrays) wird entfernt. Danach wird der index auf 1 gesetzt.
            if let firstDate = weekSlider[currentWeekIndex].first?.date, currentWeekIndex == 0 {
                /// Hier wird jetzt eine neue Woche an die 0te Stelle des Arrays hinzugefügt und das letzte Item des Arrays entfernt
                weekSlider.insert(firstDate.createPreviousWeek(), at: 0)
                weekSlider.removeLast()
                currentWeekIndex = 1
            }
            
            /// Hier versteh ich noch nicht ganz warum bei beiden subtrahiert wird.
            if let lastDate = weekSlider[currentWeekIndex].last?.date, currentWeekIndex == (weekSlider.count - 1) {
                weekSlider.append(lastDate.createNextWeek())
                weekSlider.removeFirst()
                currentWeekIndex = weekSlider.count - 2
            }
        }
    }
    
    /// Das ist meine alte func, die neue hat mir Simon von Discord erklärt
    /*func taskColor(for date: Date) -> [Color] {
        let calendar = Calendar.current
        let filteredTasks = tasks.filter { calendar.isDate($0.date, inSameDayAs: date) }
        let sortedTasks = filteredTasks.sorted(by: { $0.date < $1.date })
        
        var uniqueColor: [Color] = []
        
        
        for task in sortedTasks {
            if task.date == date { }
            if !uniqueColor.contains(task.taskCategory.color) {
                uniqueColor.append(task.taskCategory.color)
                if uniqueColor.count > 3 {
                    break
                }
            }
        }
        return uniqueColor
    }*/
    
    func taskColor(for date: Date) -> [Color] {
    let calendar = Calendar.current
    let filteredTasks = tasks.filter { calendar.isDate($0.date, inSameDayAs: date) }
    guard !filteredTasks.isEmpty else { return [] }
    
    var categorys: [Category] = []

    for task in filteredTasks where !categorys.contains(task.taskCategory) {
        categorys.append(task.taskCategory)
    }
    let colors = Array(categorys.prefix(3)).compactMap({ $0.color })

    return colors
}
}

struct TaskRowView: View {
    
    @Binding var task: Aufgabe
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            Circle()
                .fill(indicatorColor)
                .frame(width: 10, height: 10)
                .padding(4)
                .background(.white.shadow(.drop(color: .black.opacity(0.1), radius: 3)), in: .circle)
                .onTapGesture {
                    withAnimation(.snappy) {
                        task.isCompleted.toggle()
                    }
                }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(task.taskName)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                
                Label(task.date.format("HH:mm"), systemImage: "clock")
                    .font(.caption)
                    .foregroundStyle(.white)
            }
            .padding(15)
            .hAlign(.leading)
            .background(task.taskCategory.color, in: .rect(topLeadingRadius: 15, bottomLeadingRadius: 15))
            .offset(y: -8)
            .strikethrough(task.isCompleted ? true : false)
        }
        
        var indicatorColor: Color {
            if task.isCompleted {
                return .green
            }
            return .red
        }
    }
}

#Preview {
    KalendarView()
}
