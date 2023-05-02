//
//  SingleHabitView.swift
//  FU-HabitTracker
//
//  Created by Clara Toll on 2023-05-01.
//

import SwiftUI

struct SingleHabitSheet: View {
    let habit: Habit
    //let svm : SingleHabitVM
    
    var body: some View {
        VStack{
            Spacer()
            Text("Habit name: \(habit.name)")
            Spacer()
            Text("You have completed your habit \(habit.streak) times")
            Spacer()
        }
    }
    
    
}
/*
struct SingleHabitView_Previews: PreviewProvider {
    static var previews: some View {
        SingleHabitView()
    }
}
*/
