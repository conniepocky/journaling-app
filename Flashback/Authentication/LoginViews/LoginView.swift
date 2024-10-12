//
//  LoginView.swift
//  Flashback
//
//  Created by Connie Waffles on 12/10/2024.
//

import SwiftUI
import Firebase

struct LoginView: View {
    
    @State private var email = ""
    @State private var username = ""
    @State private var password = ""
    @State private var loggedIn = false
    
    @State private var emailEmptyPassResetAlert = false
    
    private var db = Firestore.firestore()
    
    var body: some View {
        if (loggedIn) {
            HomeView()
        } else {
            content
        }
    }
    
    var content: some View {
        ZStack {
            VStack {
                Text("Log In")
                    .foregroundColor(.accentColor)
                    .font(.system(size: 50))
                    .fontWeight(.semibold)
                
                Spacer()
                
                TextField("Email", text: $email)
                    .padding(6.0)
                    .background(RoundedRectangle(cornerRadius: 4.0, style: .continuous)
                                  .stroke(.gray, lineWidth: 1.0))
                    .padding()
                    .textContentType(.emailAddress)
                    .autocapitalization(.none)
                
                SecureField("Password", text: $password)
                    .padding(6.0)
                    .background(RoundedRectangle(cornerRadius: 4.0, style: .continuous)
                                  .stroke(.gray, lineWidth: 1.0))
                    .padding()
                    .textContentType(.password)
                    .autocapitalization(.none)
                
                Button {
                    login()
                } label: {
                    Text("Login.")
                        .frame(width: 200, height: 40)
                        .foregroundColor(.white)
                        .background(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                }
                
                Button {
                    if email.isEmpty {
                        emailEmptyPassResetAlert = true
                    } else {
                        resetPassword()
                    }
                } label: {
                    Text("Forgot your password?")
                }.alert(isPresented: $emailEmptyPassResetAlert) {
                    Alert(title: Text("Error: Email not filled in"), message: Text("Please enter in your email above so we can send an email password resent link."), dismissButton: .default(Text("Got it!")))
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
    
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if error != nil {
                print(error!.localizedDescription)
            }
        }
    }
    
    func resetPassword() {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            print(email)
            print("testing")
        }
    }
}

#Preview {
    LoginView()
}
