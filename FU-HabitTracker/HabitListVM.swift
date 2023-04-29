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
    @Published var selectedDate = Date()

    let db = Firestore.firestore()
    
    let auth = Auth.auth()
    
    
    func toggle (habit: Habit, selectedDate : Date, done: Bool) {
        
        guard let user = auth.currentUser else { return }
        
        var days = Days(habitID: habit.id ?? "", completedDay: selectedDate, done: done)
        
        if days.habitID == habit.id {
            
            let daysRef = db.collection("users").document(user.uid)
                                      .collection("habits").document(habit.id!)
                                      .collection("days")
    
            let timestamp = Timestamp(date: selectedDate)
            
            // Check if the document exists
            let query = daysRef.whereField("completedDay", isEqualTo: timestamp)
            
            print("hello")
            
            // Get the documents that match the query and delete them one by one
            query.getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    guard let querySnapshot = querySnapshot else { return }
                    
                    print("Number of documents found: \(querySnapshot.documents.count)")

                    // Delete the documents one by one
                    for document in querySnapshot.documents {
                        document.reference.delete() { error in
                            if let error = error {
                                print("Error removing document: \(error)")
                            } else {
                                print("Document successfully removed!")
                            }
                        }
                    }
                    
                    // Add a new document if bool is true
                    if done {
                        let days = Days(habitID: habit.id ?? "", completedDay: selectedDate, done: done)
                        do {
                            try daysRef.addDocument(from: days)
                        } catch {
                            print("Error saving to db")
                        }
                    }
                }
            }
        } else {
            days.habitID = habit.id ?? ""
        }
    }
    
    func saveToFirestore(habitName : String, dateAdded: Date){
        
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
