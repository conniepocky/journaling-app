//
//  ContentView.swift
//  Flashback
//
//  Created by Connie Waffles on 25/07/2023.
//

import SwiftUI
import Firebase

struct ContentView: View {
    
    @State private var email = ""
    @State private var username = ""
    @State private var password = ""
    @State private var loggedIn = false
    @State private var registration = false
    @State private var login = false
    
    private var db = Firestore.firestore()
    
    var body: some View {
        
        if (registration) {
            RegisterView()
        } else if (login) {
            LoginView()
        } else if (loggedIn) {
            HomeView()
        } else {
            content
        }
    }
    
    var content: some View {
        ZStack {
            VStack(spacing: 20) {
                Text("Welcome.")
                    .foregroundColor(.accentColor)
                    .font(.system(size: 50))
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button {
                    registration = true
                } label: {
                    Text("Sign Up")
                        .frame(width: 200, height: 40)
                        .foregroundColor(.white)
                        .background(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
              
                }
                
                Button {
                    login = true
                } label: {
                    Text("Already have an account? Login.")
                }
                
                
                Spacer()
                    
            }.padding(10)
        }.onAppear {
            Auth.auth().addStateDidChangeListener { auth, user in
                if user != nil {
                    loggedIn.toggle()
                }
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}