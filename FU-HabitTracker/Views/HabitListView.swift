//
//  HabitListView.swift
//  FU-HabitTracker
//
//  Created by Clara Toll on 2023-04-18.
//

import SwiftUI

struct HabitListView: View {
    
    @StateObject var habitListVM = HabitListVM()
    @State var showingAddAlert = false
    @State var newHabitName = ""
    
    var body: some View {

            VStack {
                List {
                    ForEach(habitListVM.habits){ habit in
                        RowView(habit: habit, vm: habitListVM)
                    }
                    .onDelete() { indexSet in
                        for index in indexSet {
                            habitListVM.delete(index: index)
                        }
                    }
                }
                
                Button(action: {
                    showingAddAlert = true
                }) {
                    Text("Add")
                }
                .alert("Lägg till", isPresented: $showingAddAlert){
                    TextField("lägg till", text: $newHabitName)
                    Button("add", action: {
                        habitListVM.saveToFirestore(habitName: newHabitName)
                        newHabitName = ""
                    })
                }
            }
            .padding(.top, 50)
        // add padding to move the content down so that it doesn't overlap with the status bar
        
        .onAppear(){
            habitListVM.listenToFirestore()
        }
    }
}
