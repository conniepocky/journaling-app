//
//  LoginView.swift
//  Flashback
//
//  Created by Connie Waffles on 27/07/2023.
//

import SwiftUI
import Firebase

private let defaults = UserDefaults.standard

struct LoginView: View {
    
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        
        if (ContentView.globalvars.loggedIn) {
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
                    register()
                } label: {
                    Text("Sign Up")
                        .frame(width: 200, height: 40)
                        .foregroundColor(.white)
                        .background(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
              
                }
                
                Button {
                    login()
                } label: {
                    Text("Already have an account? Login.")
                }
                
                
                Spacer()
                    
            }.padding(10)
        }
    }
    
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if error != nil {
                print(error!.localizedDescription)
            } 
        }
    }
    
    func register() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if error != nil {
                print(error!.localizedDescription)
            }
        }
        
        Auth.auth().currentUser!.createProfileChangeRequest().displayName = email.before(first: "@")
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
