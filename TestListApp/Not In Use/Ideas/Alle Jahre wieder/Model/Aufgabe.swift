//
//  Task.swift
//  TaskPlanner
//
//  Created by Michael Ilic on 09.07.24.
//

import Foundation

// MARK: Task Model
struct Aufgabe: Identifiable {
    var id: UUID = .init()
    var date: Date
    var taskName: String
    var taskDescription: String
    var isCompleted: Bool
    var taskCategory: Category
}

// MARK - timeIntervalSince1970 sind wieviele sekunden seit dem 01.01.1970 vergangen sind
var beispielAufgaben: [Aufgabe] = [
    .init(date: .now - 100, taskName: "Edit YT Video", taskDescription: "",isCompleted: true, taskCategory: .general),
    .init(date: .now - 200, taskName: "Irgendwas", taskDescription: "", isCompleted: false, taskCategory: .bug),
    .init(date: .now, taskName: "Lorem Ipsum", taskDescription: "", isCompleted: true, taskCategory: .challenge),
    .init(date: Date(timeIntervalSince1970: 1_721_817_761), taskName: "Complete Challenge", taskDescription: "", isCompleted: true, taskCategory: .idea),
    .init(date: Date(timeIntervalSince1970: 1_721_814_761), taskName: "Ein weiterer Test", taskDescription: "Dies ist ein weiterer Test um alles austesten zu können und zu sehen wie Weit etwas geht bevor es einen Zeilenumbruch machen muss. Auch für die UI gut zu sehen.", isCompleted: false, taskCategory: .challenge),
    .init(date: .now + 86_400, taskName: "Problemsuche", taskDescription: "", isCompleted: false, taskCategory: .bug),
    .init(date: .now + 86_800, taskName: "SwiftData lernen", taskDescription: "", isCompleted: false, taskCategory: .coding),
    .init(date: Date(timeIntervalSince1970: 1672901809), taskName: "Finanzbuch lesen", taskDescription: "", isCompleted: true, taskCategory: .general),
    .init(date: Date(timeIntervalSince1970: 1672923409), taskName: "Serie schauen", taskDescription: "", isCompleted: false, taskCategory: .modifiers),
]
