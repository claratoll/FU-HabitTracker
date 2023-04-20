//
//  Habit.swift
//  FU-HabitTracker
//
//  Created by Clara Toll on 2023-04-18.
//

import Foundation
import FirebaseFirestoreSwift

struct Habit : Codable, Identifiable {
    @DocumentID var id: String?
    var name : String
    var done: Bool = false
    var todaysDate: Date?
    var dateAdded: Date?
    var color: String?
    var completedDays: [Date] = []
}
