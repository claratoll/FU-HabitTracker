//
//  SignInView.swift
//  FU-HabitTracker
//
//  Created by Clara Toll on 2023-04-18.
//

import SwiftUI
import Firebase

struct SignInView: View {
    
    @Binding var signedIn : Bool
    
    var auth = Auth.auth()
    
    var body: some View{
        HStack{
            Button(action: {
                auth.signInAnonymously() {result, error in
                    if error != nil {
                        print("error signing in")
                    } else {
                        signedIn = true
                    }
                }
            }, label: {Text("Sign in")})
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.ui.atomicOrange)
    }
}
