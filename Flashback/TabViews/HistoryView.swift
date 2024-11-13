//
//  HistoryView.swift
//  Flashback
//
//  Created by Connie Waffles on 07/08/2023.
//

import SwiftUI
import Firebase

struct HistoryView: View {
    
    @EnvironmentObject var dataManager: DataManager
    var currentUser = Auth.auth().currentUser!
    
    @State var friendsPosts = [Posts]()
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                ForEach(dataManager.prompts) { prompt in
                    NavigationLink {
                        VStack(alignment: .leading) {
                            Text(prompt.text)
                                .foregroundColor(.accentColor)
                                .font(.system(.title, design: .serif, weight: .bold))
                            
                            Divider()
                            
                            if friendsPosts.count >= 1 {
                                ForEach(friendsPosts) { post in
                                    PostView(post: post, isHistory: true)
                                }
                            } else {
                                Text("No posts found for this date :(")
                                    .multilineTextAlignment(.center)
                                    .font(.title2)
                                    .foregroundStyle(.secondary)
                            }
                            
                        }.padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
                        .onAppear {
                            self.friendsPosts = []
                            
                            for post in dataManager.posts {
                                if post.prompt == prompt.id && (post.author_id == currentUser.uid || dataManager.friends.contains(post.author_id)) {
                                    if !self.friendsPosts.contains(where: {$0.id == post.id}) {
                                        self.friendsPosts.append(post)
                                    }
                                }
                            }
                        }
            
                        Spacer()
                        
                    } label: {
                        Text(prompt.date_time, format: .dateTime.day().month().year())
                            .font(.title3)
                            .foregroundColor(.secondary)
                            
                    }
                    Divider()
                }
            }.padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
                .navigationTitle("History")
        }.onAppear {
            dataManager.fetchFriends()
            
            self.friendsPosts = []
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
