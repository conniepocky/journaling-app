//
//  RegisterView.swift
//  Flashback
//
//  Created by Connie Waffles on 12/10/2024.
//

import SwiftUI
import Firebase

struct RegisterView: View {
    @State private var email = ""
    @State private var username = ""
    @State private var password = ""
    @State private var loggedIn = false
    
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
                
                Text("Create an account")
                    .foregroundColor(.accentColor)
                    .font(.system(size: 50))
                    .multilineTextAlignment(.center)
                    .fontWeight(.semibold)
                
                Spacer()
                
                TextField("Display Name", text: $username)
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
                    Text("Register")
                        .frame(width: 200, height: 40)
                        .foregroundColor(.white)
                        .background(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                }
                
                Spacer()
                
            }.padding(10)
            
        }.onAppear {
            Auth.auth().addStateDidChangeListener { auth, user in
                if user != nil {
                    if username.isValidName {
                        print("valid")
                        
                        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                        changeRequest?.displayName = username
                        changeRequest?.commitChanges { error in
                            print(error?.localizedDescription as Any)
                        }
                        
                    } else {
                        //not valid username
                        
                        print("invalid username")
                    }
                    
                    let ref = db.collection("users").document(Auth.auth().currentUser?.uid ?? "0")
                    ref.setData(["displayname": username,
                                 "friends": [String](),
                                 "requests": [String](),
                                 "id": Auth.auth().currentUser?.uid ?? "0"]) { error in
                        if let error = error {
                            print(error.localizedDescription)
                        }
                    }
                    
                    loggedIn.toggle()
                }
            }
        }
    }
    
    
    func register() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if error != nil {
                print(error!.localizedDescription)
            }
        }
    }
}

#Preview {
    RegisterView()
}
