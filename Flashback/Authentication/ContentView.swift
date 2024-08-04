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
    @State private var registation = false
    
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
            VStack(spacing: 20) {
                Text("Welcome.")
                    .foregroundColor(.accentColor)
                    .font(.system(size: 50))
                    .fontWeight(.semibold)
                
                Spacer()
                
                TextField("Username", text: $username)
                    .padding(6.0)
                    .background(RoundedRectangle(cornerRadius: 4.0, style: .continuous)
                                  .stroke(.gray, lineWidth: 1.0))
                    .padding()
                    .textContentType(.username)
                    .autocapitalization(.none)
                
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
        }.onAppear {
            Auth.auth().addStateDidChangeListener { auth, user in
                if user != nil {
                    if registation {
                        let ref = db.collection("users").document(Auth.auth().currentUser?.uid ?? "0")
                        ref.setData(["displayname": username,
                                     "friends": [String]()]) { error in
                            if let error = error {
                                print(error.localizedDescription)
                            }
                        }
                    }
                    registation = false
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
    
    func register() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if error != nil {
                print(error!.localizedDescription)
            }
        }

        if username.isValidName {
            print("valid")
            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            changeRequest?.displayName = username
            changeRequest?.commitChanges { error in
                print(error!.localizedDescription)
            }
            
            
        } else {
            //not valid username
        }
        
        registation = true
        
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
