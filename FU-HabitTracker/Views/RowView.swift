//
//  RowView.swift
//  FU-HabitTracker
//
//  Created by Clara Toll on 2023-04-18.
//

import SwiftUI

struct RowView: View {
    let habit: Habit
    let vm: HabitListVM
    let selectedDate: Date
    @State private var isSelected: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(habit.name)
                Spacer()
                Button(action: {
                    isSelected.toggle()
                    vm.toggle(habit: habit, selectedDate: selectedDate, done: isSelected)
                }) {
                    Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                }
            }
            .padding(.vertical)
            .padding(.horizontal)
            .background {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.ui.blueGray)
                    .opacity(0.5)
            }
            Divider().padding(.leading, 15)
        }
        .onAppear {
            // Check if the habit has been completed on the selected date
            vm.getDays(for: habit, on: selectedDate) { day in
                isSelected = day?.done ?? false
            }
        }
        .onChange(of: selectedDate) { _ in
            // Update isSelected when the selected date changes
            vm.getDays(for: habit, on: selectedDate) { day in
                isSelected = day?.done ?? false
            }
        }
    }
}
