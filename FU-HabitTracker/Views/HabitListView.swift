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
    @State var selectedDate = Date()

    var body: some View {
        VStack {
            CalendarView()
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
