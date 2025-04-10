//
//  Date + Extensions.swift
//  TestListApp
//
//  Created by Michael Ilic on 22.07.24.
//

import Foundation
import SwiftUI

extension Date {
    func format(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        
        return formatter.string(from: self)
    }
    
    // - Die funktion nimmt ein Datum (Standartmäßig das aktuelle) und gibt es in WeekDay Objekten als Array der Wochentage zurück
    func fetchWeek(_ date: Date = .init()) -> [WeekDay] {
        let calendar = Calendar.current
        /// startOfDay ruft den aktuellen Kalender auf und gibt den ersten existierenden Moment des gegeben Datums zurück
        let startOfDay = calendar.startOfDay(for: date)
        
        var week: [WeekDay] = []
        /// Das Wochenintervall wird hier bestimmt (also anhand welcher tag heute ist wird der anfang der Woche bis zum ende der Woche zurückgegeben.
        let weekForDate = calendar.dateInterval(of: .weekOfMonth, for: startOfDay)
        /// Wenn das errechnet Wochenintervall nicht zurückgegeben werden kann, wird ein leeres Array zurückgegeben
        guard let startOfWeek = weekForDate?.start else { return [] }
        
        (0..<7).forEach { index in
            /// Hier wird der index (immer 1) als Tag (.day) zum startOfWeek hinzugefügt. Durch die ForEach werden 7 Tage hinzugefügt.
            if let weekDay = calendar.date(byAdding: .day, value: index, to: startOfWeek) {
                week.append(.init(date: weekDay))
            }
        }
        
        return week
    }
    
    func createNextWeek() -> [WeekDay] {
        let calendar = Calendar.current
        
        /// Hier wird der letzte Tag der Woche ermittelt
        let startOfLastWeek = calendar.startOfDay(for: self)
        
        /// Hier wird der Tag nach dem letzten Tag der Woche ermittelt
        guard let nextDate = calendar.date(byAdding: .day, value: 1, to: startOfLastWeek) else { return [] }
        
        /// Hier wird die ganze Woche für den ersten Tag der berechneten Woche zurückgegeben
        return fetchWeek(nextDate)
    }
    
    // - Hier passiert genau dasselbe wie oben, nur das der erste tag der aktuellen Woche ermittelt wird und von dem dann ein tag abgezogen wird.
    func createPreviousWeek() -> [WeekDay] {
        let calendar = Calendar.current
        let startOfFirstWeek = calendar.startOfDay(for: self)
        guard let previousDate = calendar.date(byAdding: .day, value: -1, to: startOfFirstWeek) else { return [] }
        
        return fetchWeek(previousDate)
    }
    
    
    
    var isToday: Bool {
        Calendar.current.isDateInToday(self)
    }
    
    struct WeekDay: Identifiable {
        var id: UUID = .init()
        var date: Date
    }
}

extension View {
    // - Custom Spacer
    @ViewBuilder
    func hAlign(_ alignment: Alignment) -> some View {
        self
            .frame(maxWidth: .infinity, alignment: alignment)
    }
    
    @ViewBuilder
    func vAlign(_ alignment: Alignment) -> some View {
        self
            .frame(maxHeight: .infinity, alignment: alignment)
    }
    
    func isSameDate(_ date1: Date, _ date2: Date) -> Bool {
        return Calendar.current.isDate(date1, inSameDayAs: date2)
    }
}
