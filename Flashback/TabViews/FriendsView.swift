//
//  FriendsView.swift
//  Flashback
//
//  Created by Connie Waffles on 04/08/2024.
//

import SwiftUI
import Firebase

struct FriendsView: View {
    
    @ObservedObject private var viewModel = DataManager()
    @State private var currentUser = Auth.auth().currentUser
    
    private var db = Firestore.firestore()
    
    @State var names = [String]()
    
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            List {
                Section("Users") {
                    NavigationLink {
                        ForEach(searchResults) { user in
                            Button {
                                print("add friend")
                                print(viewModel.requests)
                                addFriend(id: user.id)
                            } label: {
                                Label(user.displayname, systemImage: "heart")
                            }
                        }.searchable(text: $searchText)
                            .autocapitalization(.none)
                    } label: {
                        Text("Search")
                    }
                }
                
                Section("Friends") {
                    ForEach(viewModel.friends, id: \.self) { friend in
                        Text(friend)
                    }
                }
                
                Section("Requests") {
                    ForEach(viewModel.requests, id: \.self) { request in
                        Button {
                            
                        } label: {
                            if !names.isEmpty {
                                Button {
                                    acceptRequest(id: request)
                                } label: {
                                    Text(names[0])
                                }
                            }
                        }
                    }

                }
            }.navigationBarTitle("Friends")
                      
            
        }.onAppear() {
            self.viewModel.fetchUsers()
            self.viewModel.fetchCurrentUser()
            self.viewModel.fetchFriends()
            
            for request in viewModel.requests {
                let docRef = db.collection("users").document(request)
                
                docRef.getDocument { (document, error) in
                     if let document = document, document.exists {
                         let docData = document.data()
                         // Do something with doc data
                         
                         print(docData?["displayname"] as? String)
                         
                         names.append((docData?["displayname"] as? String)!)
                      } else {
                         print("Document does not exist")

                      }
                }
            }
        }
    }
    
    
    var searchResults: [Users] {
            if searchText.isEmpty {
                return viewModel.users
            } else {
                return viewModel.users.filter { $0.displayname.contains(searchText) }
            }
        }
    
    func addFriend(id: String) {
        let ref = db.collection("users").document(id)
        
        if id != currentUser?.uid {
            ref.updateData([
                "requests": FieldValue.arrayUnion([currentUser?.uid ?? "0"])
            ])
        }
    }
    
    func acceptRequest(id: String) {
        let ref = db.collection("users").document(id)
        
        ref.updateData([
            "requests": FieldValue.arrayRemove([id]),
            "friends": FieldValue.arrayUnion([currentUser?.uid ?? "0"])
        ])
        
        let userRef = db.collection("users").document(currentUser?.uid ?? "0")
        
        userRef.updateData([
            "requests": FieldValue.arrayRemove([id]),
            "friends": FieldValue.arrayUnion([id])
        ])
    }
    
}

struct FriendsView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsView()
    }
}
