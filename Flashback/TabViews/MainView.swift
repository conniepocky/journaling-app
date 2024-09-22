//
//  MainView.swift
//  Flashback
//
//  Created by Connie Waffles on 05/08/2023.
//

import SwiftUI
import SwiftUIIntrospect
import Firebase

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
                    Text(Date.now, format: .dateTime.day().month().year())
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
                    ForEach(friendsPosts) { post in
                        HStack {
                            Text(post.author)
                                .font(.title2)
                                .foregroundColor(.accentColor)
                            
                            Text(post.date_time)
                                .foregroundColor(.gray)
    
                        }
                           
                        Text(post.text)
                            
                        Divider()
                    }
                }.padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
                
            }.introspect(.scrollView, on: .iOS(.v13, .v14, .v15, .v16, .v17)) { scrollView in
                scrollView.bounces = false
            }
        }.onAppear {
            dataManager.fetchFriends()
            print(dataManager.friends)
            
            for post in dataManager.posts {
                if post.prompt == dataManager.prompts[0].docName && (post.author_id == currentUser.uid || dataManager.friends.contains(post.author_id)) {
                    if !self.friendsPosts.contains(where: {$0.author_id == post.author_id}) {
                        self.friendsPosts.append(post)
                    }
                }
            }
        }
    }
}
