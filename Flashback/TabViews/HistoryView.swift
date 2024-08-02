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
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                ForEach(dataManager.prompts) { prompt in
                    NavigationLink {
                        VStack(alignment: .leading) {
                            ForEach(dataManager.posts) { post in
                                if post.prompt == prompt.docName {
                                    Text(post.author)
                                        .font(.title2)
                                        .foregroundColor(.accentColor)
                                    
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
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
