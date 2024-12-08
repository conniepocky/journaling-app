//
//  PostView.swift
//  Flashback
//
//  Created by Connie Waffles on 13/10/2024.
//

import SwiftUI
import Firebase
import PhotosUI

struct PostView: View {
    let post: Posts
    let isHistory: Bool
    @StateObject private var imageLoader = ImageLoader()
    
    var currentUser = Auth.auth().currentUser!
    
    public var db = Firestore.firestore()
    
    @State var likeCount = 0
    @State var isLiked = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(post.author)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.accentColor)

                Spacer()

                Text(post.date_time)
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            if post.image {
                if let image = imageLoader.image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity, maxHeight: 300)
                        .cornerRadius(10)
                        .padding(.bottom, 10)
                }
            }
            
            HStack {
                Text(post.text)
                    .font(.body)
                    .foregroundColor(.primary)
                    .lineLimit(nil)
                    .multilineTextAlignment(.leading)
                
                Button(action: {
                    if !isHistory {
                        let postRef = db.collection("posts").document(post.id)
                        
                        if !isLiked {
                            postRef.updateData([
                                "likes": FieldValue.arrayUnion([currentUser.uid])
                            ])
                            
                            likeCount += 1
                        } else {
                            postRef.updateData([
                                "likes": FieldValue.arrayRemove([currentUser.uid])
                            ])
                            
                            likeCount -= 1
                        }
                        
                        isLiked.toggle()
                    }
                    
                }) {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .foregroundColor(isLiked ? .red : .gray)
                        .font(.title2)
                    
                    Text("\(likeCount)")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                .buttonStyle(PlainButtonStyle())
            }

            Divider()
        }.onAppear {
            if post.image {
                imageLoader.loadImage(postID: post.id)
            }
            
            likeCount = post.likes.count
            
            if post.likes.contains(currentUser.uid) {
                isLiked = true
            } else {
                isLiked = false
            }
        }
    }
}
