//
//  RowView.swift
//  FU-HabitTracker
//
//  Created by Clara Toll on 2023-04-18.
//

import SwiftUI


struct RowView: View {
    let habit : Habit
    let selectedDate: Date
    let vm : HabitListVM
    @State var isSelected = false

    var body: some View{
        VStack(spacing: 0){
            HStack{
                Text(habit.name)
                Spacer()
                Button(action : {
                    isSelected.toggle()
                    vm.toggle(habit: habit, selectedDate: selectedDate, done: isSelected)
                }) {
                    Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                }

            }
            .padding(.vertical)
            .padding(.horizontal)
            .background{
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.ui.blueGray).opacity(0.5)
            }
            //.background(Color.white)
            //.cornerRadius(10)
            
            Divider().padding(.leading, 15)
        }
        }
}


/*
struct RowView_previews: PreviewProvider{
    static var previews: some View{
        RowView()
    }
}
*/
