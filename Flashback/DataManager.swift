//
//  DataManager.swift
//  Flashback
//
//  Created by Connie Waffles on 07/08/2023.
//

import Firebase
import FirebaseFirestore
import SwiftUI
import PhotosUI
import FirebaseStorage

class DataManager: ObservableObject {
    
    @Published var prompts: [Prompts] = []
    
    @Published var posts: [Posts] = []
    
    @Published var users = [Users]()
    
    public var friends = [String]()
    public var friendsNames = [String]()
    
    @State private var currentUser = Auth.auth().currentUser
    
    private var db = Firestore.firestore()
    
    init() {
        fetchPrompts()
        fetchPosts()
        fetchUsers()
        fetchFriends()
    }
    
    func fetchFriends() {
        let docRef = db.collection("users").document(currentUser?.uid ?? "0")
        
        docRef.getDocument { (document, error) in
             if let document = document, document.exists {
                 let docData = document.data()
                 // Do something with doc data
                 
                 print(docData?["friends"] as? [String])
                 
                 self.friends = (docData?["friends"] as? [String])!
                 
                 for friend in self.friends {
                     let nameRef = self.db.collection("users").document(friend)
                     
                     nameRef.getDocument { (document, error) in
                          if let document = document, document.exists {
                              let nameData = document.data()
                              // Do something with doc data
                              
                              print(nameData?["displayname"] as? String)
                              
                              if !self.friendsNames.contains(nameData?["displayname"] as? String ?? "test") {
                                  self.friendsNames.append((nameData?["displayname"] as? String)!)
                              }
                              
                           } else {
                              print("Document does not exist")
                           }
                     }
                 }
              } else {
                 print("Document does not exist")

              }
        }
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
                let date_time = data["date_time"] as? String ?? "Unknown date"

                return Posts(id: id, prompt: prompt, text: text, author: author, author_id: author_id, date_time: date_time)
            }
        }
    }
    
    func addPost(text: String, data: Data?) {
        
        let ref = db.collection("posts").document()
        
        if data != nil {
            
            let storageReference = Storage.storage().reference().child("\(ref.documentID).jpg")
            
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpg"
            
            storageReference.putData(data!, metadata: metadata) { (metadata, error) in
                if let error = error {
                    print("Error while uploading file: ", error)
                }
                
                if let metadata = metadata {
                    print("Metadata: ", metadata)
                }
            }
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm E, d MMM y"
        
        let today = Date.now
        
        ref.setData(["author_id": Auth.auth().currentUser?.uid ?? "Unknown", "author": Auth.auth().currentUser?.displayName ?? "Unknown", "text": text, "id": ref.documentID, "prompt": prompts[0].docName, "date_time": formatter.string(from: today)]) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}
