//
//  MainView.swift
//  Flashback
//
//  Created by Connie Waffles on 05/08/2023.
//

import SwiftUI
import SwiftUIIntrospect
import Firebase
import FirebaseStorage

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var dataManager: DataManager
    var currentUser = Auth.auth().currentUser!
    
    @State var friendsPosts = [Posts]()
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack {
                    if dataManager.prompts.count > 0 { 
                        Text(dataManager.prompts[0].text)
                            .foregroundColor(.accentColor)
                            .font(.system(.title, design: .serif, weight: .bold))
                            .multilineTextAlignment(.center)
                    }
                    Text(dataManager.prompts[0].date_time, format: .dateTime.day().month().year())
                        .font(.subheadline)

                }.padding()
                
                NavigationLink(destination: CreatePostView()) {
                    Text("Add a reply")
                        .frame(width: 200, height: 40)
                        .foregroundColor(.white)
                        .background(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                    
                }.padding()
                
                Divider()
                
                VStack(alignment: .leading) {
                    if friendsPosts.count >= 1 {
                        ForEach(friendsPosts) { post in
                            PostView(post: post, isHistory: false)
                        }
                    } else {
                        Text("Nothing to see here yet, why don't you add a reply and start a trend!")
                            .multilineTextAlignment(.center)
                            .font(.title2)
                            .foregroundStyle(.secondary)
                        
                    }
                }.padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
                
            }.introspect(.scrollView, on: .iOS(.v13, .v14, .v15, .v16, .v17)) { scrollView in
                scrollView.bounces = false
            }
        }.onAppear {
            dataManager.fetchFriends()
            print(dataManager.friends)
            
            for post in dataManager.posts {
                if post.prompt == dataManager.prompts[0].id && (post.author_id == currentUser.uid || dataManager.friends.contains(post.author_id)) {
                    if !self.friendsPosts.contains(where: {$0.id == post.id}) {
                        print(post.text)
                        self.friendsPosts.append(post)
                    }
                }
            }
        }
    }
}
