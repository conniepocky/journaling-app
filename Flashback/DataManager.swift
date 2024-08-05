//
//  DataManager.swift
//  Flashback
//
//  Created by Connie Waffles on 07/08/2023.
//

import Firebase
import FirebaseFirestore
import SwiftUI

class DataManager: ObservableObject {
    
    @Published var prompts: [Prompts] = []
    
    @Published var posts: [Posts] = []
    
    @Published var users = [Users]()
    
    public var requests = [String]()
    
    @State private var currentUser = Auth.auth().currentUser
    
    private var db = Firestore.firestore()
    
    init() {
        fetchPrompts()
        fetchPosts()
        fetchUsers()
    }
    
    func fetchPrompts() {
        
        db.collection("prompts").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("no documents")
                return
            }

            self.prompts = documents.map { queryDocumentSnapshot -> Prompts in
                let data = queryDocumentSnapshot.data()
                  
                let text = data["text"] as? String ?? ""
                let id = data["id"] as? Int ?? 0
                let docName = queryDocumentSnapshot.documentID
                    
                print(docName)

                return Prompts(text: text, id: id, docName: docName)
            }
        }
                    
    }
    
    func fetchUsers() {
        db.collection("users").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            self.users = documents.map { (queryDocumentSnapshot) -> Users in
                let data = queryDocumentSnapshot.data()
                let name = data["displayname"] as? String ?? ""
                let id = data["id"] as? String ?? ""
                let friends = data["friends"] as? [String] ?? [""]
                
                return Users(id: id, displayname: name, friends: friends)
            }
        }
    }
    
    func fetchCurrentUser() {
        let docRef = db.collection("users").document(currentUser?.uid ?? "0")
        
        docRef.getDocument { (document, error) in
             if let document = document, document.exists {
                 let docData = document.data()
                 // Do something with doc data
                 
                 print(docData?["requests"] as? [String])
                 
                 self.requests = (docData?["requests"] as? [String])!
              } else {
                 print("Document does not exist")

              }
        }

    }
    
    func fetchPosts() {
        
        db.collection("posts").addSnapshotListener { (querySnapshot, error) in
              guard let documents = querySnapshot?.documents else {
                print("no documents")
                return
              }

              self.posts = documents.map { queryDocumentSnapshot -> Posts in
                let data = queryDocumentSnapshot.data()
                  
                let text = data["text"] as? String ?? ""
                let id = data["id"] as? String ?? "0"
                let author = data["author"] as? String ?? ""
                let prompt = data["prompt"] as? String ?? ""
                let author_id = data["author_id"] as? String ?? ""

                return Posts(id: id, prompt: prompt, text: text, author: author, author_id: author_id)
            }
        }
    }
    
    func addPost(text: String) {
        let ref = db.collection("posts").document()
        ref.setData(["author_id": Auth.auth().currentUser?.uid ?? "Unknown", "displayName": Auth.auth().currentUser?.displayName ?? "Unknown", "text": text, "id": ref.documentID, "prompt": prompts[0].docName]) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}
