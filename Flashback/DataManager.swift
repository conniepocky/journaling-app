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
    
    private var db = Firestore.firestore()
    
    init() {
        fetchPrompts()
        fetchPosts()
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

                return Posts(id: id, prompt: prompt, text: text, author: author)
            }
        }
    }
    
    func addPost(text: String) {
        let ref = db.collection("posts").document()
        ref.setData(["author": Auth.auth().currentUser?.displayName ?? "Unknown", "text": text, "id": ref.documentID, "prompt": prompts[0].docName]) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}
