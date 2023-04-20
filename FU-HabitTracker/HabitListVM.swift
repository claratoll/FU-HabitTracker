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
    
    let db = Firestore.firestore()
    
    let auth = Auth.auth()
    
    
    func toggle (habit: Habit, selectedDate : Date) {
        
        guard let user = auth.currentUser else { return }
            let habits = db.collection("users").document(user.uid).collection("habits")

            if let id = habit.id {
                let newDoneValue = !habit.done
                let newCompletedDays: [Date]
                if newDoneValue {
                    // Add today's date to the completedDays array
                    newCompletedDays = habit.completedDays + [selectedDate]
                } else {
                    // Remove today's date from the completedDays array
                    newCompletedDays = habit.completedDays.filter { !Calendar.current.isDate($0, inSameDayAs: selectedDate) }
                }
                habits.document(id).updateData(["done": newDoneValue, "completedDays": newCompletedDays])
            }
    }
    
    func saveToFirestore(habitName : String, dateAdded: Date){
        
        guard let user = auth.currentUser else {return}
        let habitsref = db.collection("users").document(user.uid).collection("habits")
        
        
        let habit = Habit(name: habitName, dateAdded: dateAdded)
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
