//
//  HabitListView.swift
//  FU-HabitTracker
//
//  Created by Clara Toll on 2023-04-18.
//

import SwiftUI

struct HabitListView: View {
    
    @StateObject var habitListVM = HabitListVM()
    @State var showNewHabitSheet = false
    @State var selectedDate : Date
    
    init() {
        _selectedDate = State(initialValue: Date())
        
    }
    
    var body: some View {
        
        /*let filteredHabits = habitListVM.habits.filter { habit in
                    let days = habit.days.filter { day in
                        Calendar.current.isDate(day.completedDay, inSameDayAs: habitListVM.selectedDate)
                    }
                    return !days.isEmpty
                }*/
        
        VStack {
            CalendarView(selectedDate: $selectedDate)
            List {
                ForEach(habitListVM.habits){ habit in
                    RowView(habit: habit, selectedDate: selectedDate, vm: habitListVM)
                }

                .onDelete() { indexSet in
                    for index in indexSet {
                        habitListVM.delete(index: index)
                    }
                }
            }
            Button(action: {
                showNewHabitSheet = true
            }) {
                Text("Add")
            }

            .sheet(isPresented: $showNewHabitSheet) {
                AddNewHabitView(showNewHabitSheet: $showNewHabitSheet)
            }

        }
  
        .onAppear(){
            habitListVM.listenToFirestore()
        }
    }
}
