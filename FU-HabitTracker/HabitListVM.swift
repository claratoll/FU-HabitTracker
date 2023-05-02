//
//  HabitListVM.swift
//  FU-HabitTracker
//
//  Created by Clara Toll on 2023-04-18.
//

import Foundation
import Firebase

class HabitListVM : ObservableObject {
    
    @Published var habits = [Habit]()
    @Published var days = [Days]()
    @Published var selectedDate = Date()
    
    
    let db = Firestore.firestore()
    
    let auth = Auth.auth()
    
    
    func addToStreak (habit: Habit){
        var streak = habit.streak
        let todaysDate = Date()
        let calendar = Calendar.current
        
        guard let user = auth.currentUser else { return }
        
        // Calculate the start and end dates for the streak
        let endDate = Date()
        
        print("Streak 1 \(streak)")
        
        let daysRef = db.collection("users").document(user.uid).collection("habits").document(habit.id!).collection("days")
        let habitsRef = db.collection("users").document(user.uid).collection("habits").document(habit.id!)
        
        daysRef.getDocuments{ (querySnapshot, error) in
            if let error = error {
                print("error getting documents: \(error)")
            } else if let documents = querySnapshot?.documents {
                streak = 0
                print("streak 2 \(streak)")
                
                //create an array of the days.completedDay - days and sort them with the latest date (today) as the first place.
                
                var complDays : [Date] = []
                for document in documents {
                    let data = document.data()
                    let isCompleted = data["done"] as! Bool
                    if isCompleted{
                        let completedDate = data["completedDay"] as! Timestamp
                        complDays.append(completedDate.dateValue())
                        
                    }
                }
                complDays.sort(by: { $0 > $1})
                
                for date in complDays {
                    print(date)
                }
                
                if let firstDate = complDays.first{
                    let firstDateComponents = calendar.dateComponents([.year, .month, .day], from: firstDate)
                    let firstDateWithoutTime = calendar.date(from: firstDateComponents)!
                    let todaysDateComponents = calendar.dateComponents([.year, .month, .day], from: todaysDate)
                    let todaysDateWithoutTime = calendar.date(from: todaysDateComponents)!
                    
                    if firstDateWithoutTime == todaysDateWithoutTime {
                        streak += 1
                        print("streak \(streak)")
                    } else {
                        streak = 0
                        print("no streak added")
                    }
                }
                
                for index in 0..<complDays.count-1 {
                    let daysBetween = calendar.dateComponents([.day], from: complDays[index+1], to: complDays[index]).day
                    if daysBetween == 1 {
                        streak += 1
                        print("days streak \(streak)")
                    } else if daysBetween != nil {
                        break
                    }
                }

                print("........")
                    
            }
            habitsRef.updateData(["streak": streak]) { error in
                if let error = error {
                    print("error updating habit streak: \(error)")
                }
                
            }
        }
        
    
        
            
            /* 1. kolla om dagens datum finns i dates
             om dagens datum inte finns -> lägg till dagens datum i dates
             om dagens datum finns -> ingenting?
             
             Varje gång ett datum läggs till - itierera bakifrån i listan
             - jämför datumet med föregående datum i listan
             - om skillnaden är 1 -> lägg på 1 i streak
             - om skillnaden är mer än 1 -> sätt streak till 0
             
             */
            
    }
        
    func toggle (habit: Habit, selectedDate : Date, done: Bool) {
            addToStreak(habit: habit)
            
            
            guard let user = auth.currentUser else { return }
            
            let days = Days(habitID: habit.id ?? "", completedDay: selectedDate, done: done)
            
            if days.habitID == habit.id {
                
                let daysRef = db.collection("users").document(user.uid).collection("habits").document(habit.id!).collection("days")
                
                
             /*   daysRef.addSnapshotListener { snapshot, error in
                    guard let snapshot = snapshot else {
                        print("error fetching habits: \(error!)")
                        return
                    }
                    
                    
                
                }*/
                
                
                // Get all the documents in the collection
                daysRef.getDocuments { (querySnapshot, error) in
                    if let error = error {
                        print("Error getting documents: \(error)")
                    } else {
                        guard let querySnapshot = querySnapshot else { return }
                        
                        var documentExists = false
                        
                        // Loop through the documents and check if a document with today's date already exists
                        for document in querySnapshot.documents {
                            if let documentDate = document.get("completedDay") as? Timestamp {
                                let calendar = Calendar.current
                                if calendar.isDate(documentDate.dateValue(), inSameDayAs: selectedDate) {
                                    documentExists = true
                                    // Update the "done" field in the existing document
                                    document.reference.updateData(["done": done]) { error in
                                        if let error = error {
                                            print("Error updating document: \(error)")
                                        } else {
                                            print("Document successfully updated!")
                                        }
                                    }
                                    break
                                }
                            }
                        }
                        
                        if !documentExists {
                            // No document with today's date exists, create a new one
                            let days = Days(habitID: habit.id ?? "", completedDay: selectedDate, done: done)
                            do {
                                try daysRef.addDocument(from: days)
                            } catch {
                                print("Error saving to db")
                            }
                        }
                    }
                }
            }
        }
    
        
    func getDays(for habit: Habit, on date: Date, completion: @escaping (Days?) -> Void) {
            
            //update the calendar with the days that are completed
            //so that if the user selects a date the "done" button will update with the correct value
            
            guard let user = auth.currentUser else { return }
            
            let daysRef = db.collection("users").document(user.uid).collection("habits").document(habit.id ?? "").collection("days")
            
            let startOfDay = Calendar.current.startOfDay(for: date)
            let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!
            
            let query = daysRef.whereField("completedDay", isGreaterThan: Timestamp(date: startOfDay))
                .whereField("completedDay", isLessThan: Timestamp(date: endOfDay))
            
            query.getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                    completion(nil)
                } else {
                    if let document = querySnapshot?.documents.first,
                       let day = try? document.data(as: Days.self) {
                        completion(day)
                    } else {
                        completion(nil)
                    }
                }
            }
        }
        
        
    func saveToFirestore(habitName : String, dateAdded: Date){
            
            //saves new habit to firestore
            
            guard let user = auth.currentUser else {return}
            
            let habit = Habit(name: habitName, dateAdded: dateAdded)
            
            let habitsref = db.collection("users").document(user.uid).collection("habits")
            
            
            do {
                try habitsref.addDocument(from: habit)
            } catch {
                print("error saving to db")
            }
        }
        
    func listenToFirestore(){
            
            //collects all habits from firestore
            
            guard let user = auth.currentUser else {return}
            let habitsref = db.collection("users").document(user.uid).collection("habits")
            
            
            habitsref.addSnapshotListener(){
                snapshot, err in
                
                guard let snapshot = snapshot else {return}
                
                if let err = err {
                    print("error getting document \(err)")
                } else {
                    self.habits.removeAll()
                    
                    for document in snapshot.documents {
                        do {
                            let habit = try document.data(as : Habit.self)
                            self.habits.append(habit)
                        } catch {
                            print("error reading from db")
                        }
                    }
                    
                }
                
            }
        }
    
    func delete(index: Int) {
        guard let user = auth.currentUser else {return}
        let habitsref = db.collection("users").document(user.uid).collection("habits")
        
        let habit = habits[index]
        if let id = habit.id {
            habitsref.document(id).delete()
        }
        
    }
}
