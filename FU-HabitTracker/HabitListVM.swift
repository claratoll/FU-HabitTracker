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

    let db = Firestore.firestore()
    let auth = Auth.auth()
    
    func addToStreak (habit: Habit){
        //add to streak number - function
        
        var streak = 0
        let todaysDate = Date()
        let calendar = Calendar.current
        var yesterday = calendar.date(byAdding: .day, value: -1, to: todaysDate)!
        
        guard let user = auth.currentUser else { return }
        
        //get data from firebase
        let daysRef = db.collection("users").document(user.uid).collection("habits").document(habit.id!).collection("days").order(by: "completedDay", descending: true)
        let habitsRef = db.collection("users").document(user.uid).collection("habits").document(habit.id!)
        
        
        daysRef.getDocuments{ (querySnapshot, error) in
            if let error = error {
                print("error getting documents: \(error)")
            } else if let documents = querySnapshot?.documents {
                
                //create an array of the days.completedDay - with only the dates that has done = true
                var complDays : [Date] = []
                for document in documents {
                    let data = document.data()
                    let isCompleted = data["done"] as! Bool
                    if isCompleted{
                        let completedDate = data["completedDay"] as! Timestamp
                        complDays.append(completedDate.dateValue())
                    }
                }
                
                // to check if the first day is in the array
                let firstDate = complDays.first ?? Date()
                
                let sameDay = calendar.isDate(todaysDate, equalTo: firstDate, toGranularity: .day)
                print("same day is \(sameDay)")
                
                if sameDay {
                    streak += 1
                    
                    //loop through the rest of the array to see if it contains any date values that are in order so that the user gets extra points to the streak value
                    var checkNext = true
                              
                    while checkNext {
                        if complDays.contains(where: { calendar.isDate($0, inSameDayAs: yesterday)}){
                            yesterday = calendar.date(byAdding: .day, value: -1, to: yesterday)!
                            streak += 1
                        } else {
                            checkNext = false
                        }
                    }
                } else {
                    streak = 0
                    print("no streak added: \(streak)")
                }


                print("streak finished counting \(streak)")
                
                //update the streak on firebase
                habitsRef.updateData(["streak": streak]) { error in
                    if let error = error {
                        print("error updating habit streak: \(error)")
                    }
                }
            }
        }
    }
        
    func toggle (habit: Habit, selectedDate : Date, done: Bool) {
        //function to get toggle the done on the correct date in firebase and in app
        
        addToStreak(habit: habit)
        
        guard let user = auth.currentUser else { return }
        let days = Days(habitID: habit.id ?? "", completedDay: selectedDate, done: done)
        
        if days.habitID == habit.id {
            let daysRef = db.collection("users").document(user.uid).collection("habits").document(habit.id!).collection("days")
            
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
        
        habitsref.addSnapshotListener(){ snapshot, err in
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
