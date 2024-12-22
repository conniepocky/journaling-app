//
//  HomeView.swift
//  Flashback
//
//  Created by Connie Waffles on 25/07/2023.
//

import SwiftUI
import Firebase

struct HomeView: View {
    
    @State private var loggedIn = true
    
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
        
        if (loggedIn) {
            content
        } else {
            ContentView()
        }
    }
    
    var content: some View {
        TabView {
            MainView().environmentObject(DataManager()).tabItem() {
                Image(systemName: "house.fill")
                Text("Home")
            }
            HistoryView().environmentObject(DataManager()).tabItem() {
                Image(systemName: "clock.fill")
                Text("History")
            }
            FriendsView().tabItem() {
                Image(systemName: "person.2.fill")
                Text("Friends")
            }
            ProfileView().tabItem() {
                Image(systemName: "person.circle")
                Text("Profile")
            }
            
        }.onAppear {
            Auth.auth().addStateDidChangeListener { auth, user in
                if user == nil {
                    loggedIn = false
                }
            }
        }
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
