//
//  DatePickerCalendar.swift
//  FU-HabitTracker
//
//  Created by Clara Toll on 2023-04-19.
//

import SwiftUI

struct CalendarView: View {
    @State var selectedDate = Date()
    
    var body: some View {
        VStack {
            DatePicker("Select Date", selection: $selectedDate,
                       in: ...Date(), displayedComponents: .date)
                .datePickerStyle(.graphical)
                .accentColor(Color.ui.blueGray)
           // FormattedDate(selectedDate: selectedDate, omitTime: true)
        }
    }
}




struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
