//
//  DatePickerCalendar.swift
//  FU-HabitTracker
//
//  Created by Clara Toll on 2023-04-19.
//

import SwiftUI

struct CalendarView: View {
    @Binding var selectedDate : Date
    @State var completedDays: [Date] = []
    
    var body: some View {
        VStack {
            DatePicker("Select Date", selection: $selectedDate,
                       in: ...Date(), displayedComponents: .date)
                .datePickerStyle(.graphical)
                .accentColor(Color.ui.blueGray)
                .onChange(of: selectedDate) { newValue in
                        if !completedDays.contains(newValue) {
                            completedDays.append(newValue)
                        }
                    }

                .onAppear {
                    if !completedDays.contains(selectedDate) {
                        completedDays.append(selectedDate)
                                }
                            }
                .onDisappear {
                    if let index = completedDays.firstIndex(of: selectedDate) {
                        completedDays.remove(at: index)
                }
                    print("\(selectedDate)")
            }
        }
    }
}



/*
struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
*/
