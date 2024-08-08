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
                            ForEach(friendsPosts) { post in
                                if post.prompt == prompt.docName {
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
                            }
                        }.padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
                        
                        Spacer()
                    } label: {
                        Text(prompt.text)
                            .font(.title3)
                            .foregroundColor(.secondary)
                            
                    }
                    Divider()
                }
            }.padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
        }.onAppear {
            dataManager.fetchFriends()
            
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

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
