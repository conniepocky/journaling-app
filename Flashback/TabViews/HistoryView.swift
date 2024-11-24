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
    
    @State private var selectedDate: Date = Date()
    @State private var filteredPrompt: Prompts?
    
    @State var friendsPosts = [Posts]()
    
    var body: some View {
        NavigationStack {
            VStack {
                Section {
                    List {
                        DatePicker("Select a past Date", selection: $selectedDate, displayedComponents: [.date])
                            .datePickerStyle(GraphicalDatePickerStyle())
                            .frame(maxHeight: 400)
                        
                        if let prompt = dataManager.prompts.first(where: {
                            Calendar.current.isDate($0.date_time, inSameDayAs: selectedDate)
                        }) {
                            NavigationLink {
                                PastPrompt(prompt: prompt, friendsPosts: friendsPosts)
                                    .onAppear {
                                        fetchFriendsPosts(for: prompt)
                                    }
                            } label: {
                                Text(prompt.text)
                                    .foregroundStyle(Color.accentColor)
                                    .font(.title3)
                            }
                        } else {
                            
                            Text("No prompts found for the selected date.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .padding(.vertical)
                        }
                    }
                }
            }.navigationTitle("History")

            
//                Section {
//                    VStack(alignment: .leading) {
//                        ForEach(dataManager.prompts) { prompt in
//                            NavigationLink {
//                                PastPrompt(prompt: prompt, friendsPosts: friendsPosts)
//                                    .onAppear {
//                                        self.friendsPosts = []
//
//                                        for post in dataManager.posts {
//                                            if post.prompt == prompt.id && (post.author_id == currentUser.uid || dataManager.friends.contains(post.author_id)) {
//                                                if !self.friendsPosts.contains(where: {$0.id == post.id}) {
//                                                    self.friendsPosts.append(post)
//                                                }
//                                            }
//                                        }
//                                    }
//                            } label: {
//                                Text(prompt.date_time, format: .dateTime.day().month().year())
//                                    .font(.title3)
//                                    .foregroundColor(.secondary)
//
//                            }
//                            Divider()
//                        }
//                    }.padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
//                }
        }.onAppear {
            dataManager.fetchFriends()
            
            self.friendsPosts = []
        }
    }
    
    private func fetchFriendsPosts(for prompt: Prompts) {
        friendsPosts = []

        for post in dataManager.posts {
            if post.prompt == prompt.id &&
                (post.author_id == currentUser.uid || dataManager.friends.contains(post.author_id)) {
                if !friendsPosts.contains(where: { $0.id == post.id }) {
                    friendsPosts.append(post)
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
