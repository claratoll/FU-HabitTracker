//
//  AddNewHabitView.swift
//  FU-HabitTracker
//
//  Created by Clara Toll on 2023-04-19.
//

import SwiftUI

struct AddNewHabitView: View {
    @State var newHabitName = ""
    @StateObject var habitListVM = HabitListVM()
    @Binding var showNewHabitSheet: Bool
    
    var body: some View {
            VStack{
                Spacer()
                    TextField("lägg till", text: $newHabitName)
                        .font(.title)
                        .padding()
                        .overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder(Color.ui.lightGreen, style: StrokeStyle(lineWidth: 1.0)))
                        .background(Color.ui.lightGreen)
                        .padding(.horizontal, 15)

                        Button("add", action: {
                            habitListVM.saveToFirestore(habitName: newHabitName, dateAdded: Date())
                            newHabitName = ""
                            showNewHabitSheet = false
                        })
                        
                Spacer()
            }
            
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.ui.rosy)
    }
}

