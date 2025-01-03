//
//  SettingsView.swift
//  Flashback
//
//  Created by Connie Waffles on 02/08/2023.
//

import SwiftUI
import Firebase

struct SettingsView: View {
    
    @State private var currentUser = Auth.auth().currentUser
    private var db = Firestore.firestore()
    
    @State private var newDisplayName = ""
    @State private var newPassword = ""
    @State private var oldPassword = ""
    @State private var newEmailAddress = ""
    @State private var emailPasswordAuthenticate = ""
    
    @State private var confirmDelete = false
    
    var body: some View {
        VStack {
            List {
                Section {
                    NavigationLink {
                        ChangeUserView()
                        
                    } label: {
                        Text("Display name: \(currentUser?.displayName ?? "")")
                    }
                    
                    NavigationLink {
                        TextField("New Email Address", text: $newEmailAddress)
                            .padding(6.0)
                            .background(RoundedRectangle(cornerRadius: 4.0, style: .continuous)
                                .stroke(.gray, lineWidth: 1.0))
                            .padding()
                            .textContentType(.emailAddress)
                            .autocapitalization(.none)
                        
                        SecureField("Password", text: $emailPasswordAuthenticate)
                            .padding(6.0)
                            .background(RoundedRectangle(cornerRadius: 4.0, style: .continuous)
                                .stroke(.gray, lineWidth: 1.0))
                            .padding()
                            .textContentType(.password)
                            .autocapitalization(.none)
                        
                        Button {
                            updateEmailAddress(email: newEmailAddress, password: emailPasswordAuthenticate)
                        } label: {
                            Text("Save")
                                .frame(width: 200, height: 40)
                                .foregroundColor(.white)
                                .background(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                        }
                    } label: {
                        Text("Email: \(currentUser?.email ?? "")")
                    }
                    
                    NavigationLink {
                        TextField("New Password", text: $newPassword)
                            .padding(6.0)
                            .background(RoundedRectangle(cornerRadius: 4.0, style: .continuous)
                                .stroke(.gray, lineWidth: 1.0))
                            .padding()
                            .textContentType(.emailAddress)
                            .autocapitalization(.none)
                        
                        SecureField("Old Password", text: $oldPassword)
                            .padding(6.0)
                            .background(RoundedRectangle(cornerRadius: 4.0, style: .continuous)
                                .stroke(.gray, lineWidth: 1.0))
                            .padding()
                            .textContentType(.password)
                            .autocapitalization(.none)
                        
                        Button {
                            updatePassword(newPassword: newPassword, oldPassword: oldPassword)
                        } label: {
                            Text("Save")
                                .frame(width: 200, height: 40)
                                .foregroundColor(.white)
                                .background(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                            
                        }
                    } label: {
                            Text("Password")
                    }
                        
                    
                }.navigationTitle("Settings")
                
                Section(footer:
                            HStack(alignment: .center) {
                    Spacer()
                    
                    Button {
                        logout()
                    } label: {
                        Text("Log Out")
                            .frame(width: 150, height: 40)
                            .foregroundColor(.white)
                            .background(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                        
                    }
                    
                    Button {
                        confirmDelete = true
                    } label: {
                        Text("Delete Account")
                            .frame(width: 150, height: 40)
                            .foregroundColor(.white)
                            .background(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                        
                    }.alert("Account Deletation", isPresented: $confirmDelete) {
                        Button("Yes, delete") {
                            deleteAccount()
                        }
                        Button("No", role: .cancel) { }
                    } message: {
                        Text("Are you sure you wish to delete your account? This action is irreversible.")
                    }
                    
                    Spacer()
                    
                }) {
                    EmptyView()
                }
                    
            }
            
        }
    }
    
    func deleteAccountDocument() async {
        do {
            try await db.collection("users").document(currentUser!.uid).delete()
            print("Document successfully removed!")
        } catch {
            print("Error removing document: \(error)")
        }
    }

    
    func deleteAccount() {
        Task {
            await deleteAccountDocument()
        }

        currentUser?.delete { error in
          if let _ = error {
            // An error happened.
          } else {
            // Account deleted.
          }
        }
        
        do {
            try Auth.auth().signOut()
        } catch {
            print("sign out failed")
        }
    }
    
    func updateEmailAddress(email: String, password: String) {
        let user = Auth.auth().currentUser

        let credential = EmailAuthProvider.credential(withEmail: user!.email!, password: password)

        user?.reauthenticate(with: credential, completion: { (authResult, error) in
           if let _ = error {
              // Handle re-authentication error
              return
           }
           user?.updateEmail(to: email, completion: { (error) in
              if let _ = error {
                 // Handle password update error
                 return
              }
              // Password update successful
           })
        })
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("sign out failed")
        }
    }
    
    func updatePassword(newPassword: String, oldPassword: String) {
        let user = Auth.auth().currentUser

        let credential = EmailAuthProvider.credential(withEmail: user!.email!, password: oldPassword)

        user?.reauthenticate(with: credential, completion: { (authResult, error) in
           if let error = error {
              // Handle re-authentication error
              return
           }
           user?.updatePassword(to: newPassword, completion: { (error) in
              if let error = error {
                 // Handle password update error
                 return
              }
              // Password update successful
           })
        })
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
