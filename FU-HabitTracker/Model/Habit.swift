//
//  Habit.swift
//  FU-HabitTracker
//
//  Created by Clara Toll on 2023-04-18.
//

import SwiftUI
import FirebaseFirestoreSwift

struct Habit : Codable, Identifiable {
    @DocumentID var id: String?
    var name : String
    var done: Bool = false
    var dateAdded: Date?
    var days: [Days] = []
    var streak : Int = 1
}
