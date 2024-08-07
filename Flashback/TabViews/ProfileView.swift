//
//  ProfileView.swift
//  Flashback
//
//  Created by Connie Waffles on 01/08/2023.
//

import Firebase
import SwiftUI
import Introspect

struct ProfileView: View {
    
    @State private var currentUser = Auth.auth().currentUser
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    HStack {
                        Text("Profile")
                            .font(.largeTitle.bold())

                        Spacer()

                        NavigationLink {
                            SettingsView()
                        } label: {
                            Image(systemName: "pencil.circle.fill")
                                .font(.largeTitle)
                                .foregroundColor(.accentColor)
                        }
                    }
                    
                    Divider()
                }
                .padding()
                
                VStack(alignment: .leading) {
                    Text(currentUser?.displayName ?? "")
                        .font(.title)
                        .padding()
                }
                
                Spacer()
            }.introspect(.scrollView, on: .iOS(.v13, .v14, .v15, .v16, .v17)) { scrollView in
                scrollView.bounces = false
            }
            .navigationBarHidden(true)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
