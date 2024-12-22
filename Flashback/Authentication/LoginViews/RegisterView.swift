//
//  RegisterView.swift
//  Flashback
//
//  Created by Connie Waffles on 12/10/2024.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct RegisterView: View {
    @State private var email = ""
    @State private var username = ""
    @State private var password = ""
    @State private var loggedIn = false
    
    @State private var invalidUsername = false
    @State private var errorCreatingAccount = false
    @State private var verificationError = ""
    
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
                    if !username.isValidName {
                        invalidUsername = true
                    } else {
                        invalidUsername = false
                        register()
                    }
                } label: {
                    Text("Register")
                        .frame(width: 200, height: 40)
                        .foregroundColor(.white)
                        .background(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                }
                
                Spacer()
                    .alert(isPresented: $invalidUsername) {
                        Alert(title: Text("Invalid Display Name"), message: Text("Display name must contain 1-20 characters, with no special characters or numbers."), dismissButton: .default(Text("Got it!")))
                    }
                
                Text("")
                    .alert(isPresented: $errorCreatingAccount) {
                        Alert(title: Text("Error"), message: Text(verificationError), dismissButton: .default(Text("Got it!")))
                    }
                
            }.padding(10)
            
        }.onAppear {
            Auth.auth().addStateDidChangeListener { auth, user in
                if user != nil {
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.displayName = username
                    changeRequest?.commitChanges { error in
                        print(error?.localizedDescription as Any)
                    }
                    
                    loggedIn.toggle()
                }
            }
        }
    }
    
    
    func register() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if error != nil {
                verificationError = error?.localizedDescription ?? "There was an error creating your account. Please try again with a different email."
                errorCreatingAccount = true
            } else {
                print("user name is" ,username)
                
                let ref = db.collection("users").document(Auth.auth().currentUser?.uid ?? "0")
                ref.setData(["displayname": username,
                             "friends": [String](),
                             "id": Auth.auth().currentUser?.uid ?? "0"]) { error in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                }
                
                sendEmailLink()
            }
        }
    }
    
    func sendEmailLink() {
        Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
            if error != nil {
                verificationError = error?.localizedDescription ?? "There was an error sending the email verification link."
                errorCreatingAccount = true
            } else {
                print("sent link!")
            }
        })
    }
}

#Preview {
    RegisterView()
}
