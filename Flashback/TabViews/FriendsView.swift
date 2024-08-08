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

    
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            List {
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
                    Text("Search users...")
                }
                
                Section("Friends") {
                    ForEach(viewModel.friendsNames, id: \.self) { friend in
                        Text(friend)
                    }
                }
                
                Section("Requests") {
                    ForEach(Array(zip(viewModel.requests, viewModel.requestsNames)), id: \.0) { request in
                        if !request.1.isEmpty {
                            Button {
                                acceptRequest(id: request.0)
                            } label: {
                                Text(request.1)
                            }
                        }
                    }

                }
            }.navigationBarTitle("Friends")
                      
            
        }.onAppear() {
            self.viewModel.fetchUsers()
            self.viewModel.fetchRequests()
            self.viewModel.fetchFriends()
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
