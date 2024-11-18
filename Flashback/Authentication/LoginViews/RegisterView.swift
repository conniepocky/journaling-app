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
    @State private var emailLinkSent = false
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
                }.alert(isPresented: $invalidUsername) {
                    Alert(title: Text("Invalid Display Name"), message: Text("Display name must contain 1-20 characters, no special characters and only letters, numbers and underscores allowed."), dismissButton: .default(Text("Got it!")))
                }.alert(isPresented: $emailLinkSent) {
                    Alert(title: Text("Verification Link"), message: Text("Please check your email for an email verification link"), dismissButton: .default(Text("Got it!")))
                }.alert(isPresented: $errorCreatingAccount, content: {
                    Alert(title: Text("Error"), message: Text(verificationError), dismissButton: .default(Text("Got it!")))
                })
                
                Spacer()
                
            }.padding(10)
            
        }.onAppear {
            Auth.auth().addStateDidChangeListener { auth, user in
                if user != nil {
                    
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.displayName = username
                    changeRequest?.commitChanges { error in
                        print(error?.localizedDescription as Any)
                    }
                    
                    let ref = db.collection("users").document(Auth.auth().currentUser?.uid ?? "0")
                    ref.setData(["displayname": username,
                                 "friends": [String](),
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
                verificationError = error?.localizedDescription ?? "There was an error creating your account. Please try again with a different email."
                errorCreatingAccount = true
            } else {
                sendEmailLink()
            }
        }
    }
    
    func sendEmailLink() {
        Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
            // Notify the user that the mail has sent or couldn't because of an error.
            if error != nil {
                verificationError = error?.localizedDescription ?? "There was an error sending the email verification link."
                errorCreatingAccount = true
            } else {
                self.emailLinkSent = true
                print("sent link!")
            }
        })
    }
}

#Preview {
    RegisterView()
}
