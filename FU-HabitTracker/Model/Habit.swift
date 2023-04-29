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
    var doneDate: Date?
    var dateAdded: Date?
    var color: String?
    var completedDays: [Date] = []
    var days: [Days] = []
    var streak : Int = 1

}




/*
struct extrahabit{
    var name : String
    var dates : [Date] = []
    var streak : Int = 1
}
 1. kolla om dagens datum finns i dates
        om dagens datum inte finns -> lägg till dagens datum i dates
        om dagens datum finns -> ingenting?
 
 Varje gång ett datum läggs till - itierera bakifrån i listan
    - jämför datumet med föregående datum i listan
    - om skillnaden är 1 -> lägg på 1 i streak
    - om skillnaden är mer än 1 -> sätt streak till 0
 
 
 
 /users/{uid}/habits/{habit}/dates/{date}
*/
