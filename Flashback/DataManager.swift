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
    
    public var friends = [String]()
    
    @Published var friendsDictionary = [String: String]()
    
    @State private var currentUser = Auth.auth().currentUser
    
    private var db = Firestore.firestore()
    
    init() {
        fetchPrompts()
        fetchPosts()
        fetchFriends()
    }
    
    func fetchFriends() {
        
        let docRef = db.collection("users").document(currentUser?.uid ?? "0")
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let docData = document.data()
                
                let friends = (docData?["friends"] as? [String]) ?? []

                for friend in friends {
                    let nameRef = self.db.collection("users").document(friend)
                    
                    nameRef.getDocument { (document, error) in
                        if let document = document, document.exists {
                            let nameData = document.data()
                            let displayName = nameData?["displayname"] as? String ?? "Unknown"
                            
                            self.friendsDictionary[friend] = displayName
                            
                            print("fetched friends")
                            
                        } else {
                            print("Document does not exist for friend ID: \(friend)")
                        }
                    }
                }
            } else {
                print("Document does not exist for the current user.")
            }
        }
    }
    
    func fetchPrompts() {
        
        db.collection("prompts")
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("no documents")
                return
            }

            self.prompts = documents.map { queryDocumentSnapshot -> Prompts in
                
                let data = queryDocumentSnapshot.data()
                  
                let text = data["text"] as? String ?? ""
                
                var dt = data["timestamp"] as? Timestamp
                let date_time = dt?.dateValue() ?? Date.now
                
                let id = queryDocumentSnapshot.documentID
                
                print("fetched prompts")

                return Prompts(text: text, id: id, date_time: date_time)
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
                let image = data["image"] as? Bool ?? false
                let date_time = data["date_time"] as? String ?? "Unknown date"
                let likes = data["likes"] as? [String] ?? []
                  
                print("fetched postsfe")

                return Posts(id: id, prompt: prompt, text: text, author: author, author_id: author_id, date_time: date_time, image: image, likes: likes)
            }
        }
    }
    
    func addPost(text: String, data: Data?, selectedImg: Bool) {
        
        let ref = db.collection("posts").document()
        
        if selectedImg {
            
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
        
        ref.setData(["author_id": Auth.auth().currentUser?.uid ?? "Unknown", "author": Auth.auth().currentUser?.displayName ?? "Unknown", "text": text, "id": ref.documentID, "prompt": prompts[0].id, "likes": [], "image": selectedImg, "date_time": formatter.string(from: today)]) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}
