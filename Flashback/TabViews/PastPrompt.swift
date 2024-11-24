//
//  PastPrompt.swift
//  Flashback
//
//  Created by Connie Waffles on 24/11/2024.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct PastPrompt: View {
    
    let prompt: Prompts
    let friendsPosts: [Posts]
    
    @EnvironmentObject var dataManager: DataManager
    var currentUser = Auth.auth().currentUser!
    
    var body: some View {
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

        Spacer()
    }
}
