//
//  ContentView.swift
//  FU-HabitTracker
//
//  Created by Clara Toll on 2023-04-18.
//

import SwiftUI
import Firebase

struct ContentView: View {
    @State var signedIn = false
    
    var body: some View{
            if !signedIn{
                SignInView(signedIn: $signedIn)
            } else {
                HabitListView()
            }
    }
}
        





struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
