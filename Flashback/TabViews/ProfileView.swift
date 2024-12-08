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
        NavigationStack {
            VStack() {
                Text(currentUser?.displayName ?? "")
                    .font(.title)
                    .padding()
                
                Divider()
                
            }.navigationTitle("Profile")
            .toolbar {
                NavigationLink {
                    SettingsView()
                } label: {
                    Image(systemName: "pencil.circle.fill")
                        .foregroundColor(.accentColor)
                        .font(.title3)
                }
            }
            
            Section {
                
                ShareLink(item: "Download Past & Present app!") {
                    Label("Share this app with friends!", systemImage: "square.and.arrow.up")
                }
                
                if !(currentUser?.isEmailVerified ?? true) {
                    Text("Please check your inbox to verify your email!")
                }
                
            }.padding()
            
            Spacer()
        }.onAppear {
            Auth.auth().currentUser?.getIDTokenForcingRefresh(true)
            Auth.auth().currentUser?.reload()
            
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
