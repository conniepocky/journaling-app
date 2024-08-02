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
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack {
                    if dataManager.prompts.count > 0 { Text(dataManager.prompts[0].text)
                            .foregroundColor(.accentColor)
                            .font(.title)
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
                    ForEach(dataManager.posts) { post in
                        if post.prompt == dataManager.prompts[0].docName {
                            Text(post.author)
                                .font(.title2)
                                .foregroundColor(.accentColor)
                               
                            Text(post.text)
                                
                            Divider()
                        }
                    }
                }.padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
                
            }.introspect(.scrollView, on: .iOS(.v13, .v14, .v15, .v16, .v17)) { scrollView in
                scrollView.bounces = false
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
