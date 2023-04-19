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

            Spacer()

                TextField("lägg till", text: $newHabitName)
                    .font(.title)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder(Color.ui.lightGreen, style: StrokeStyle(lineWidth: 1.0)))
                    .background(Color.ui.lightGreen)
                    .padding(.horizontal, 15)

            HStack{
                    ForEach(1...5, id: \.self) { index in
                    
                        let atomicOrange = Color("AtomicOrange")
                        let blueGray = Color("BlueGray")
                        let lightGray = Color("LightGray")
                        let lightGreen = Color("LightGreen")
                        let rosy = Color("Rosy")

                        Circle()
                            .fill(Color.ui.blueGray)
                            .frame(width: 30, height: 30)
                        // .overlay(content: {
                        //  if color == habitListVM.habitColor{
                        //    Image(systemName: "checkmark")
                        //      .font(.caption.bold())
                        // })
                    }
                }

            
                    Button("add", action: {
                        habitListVM.saveToFirestore(habitName: newHabitName, dateAdded: Date())
                        newHabitName = ""
                        showNewHabitSheet = false
                    })
            Spacer()


        
    }
    }

/*
struct AddNewHabitView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewHabitView(showNewHabitSheet: $showNewHabitSheet)
    }
}

*/
