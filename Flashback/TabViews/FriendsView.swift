//
//  FriendsView.swift
//  Flashback
//
//  Created by Connie Waffles on 04/08/2024.
//

import SwiftUI

struct FriendsView: View {
    
    @ObservedObject private var viewModel = DataManager()
    
    var body: some View {
        NavigationView {
            List(viewModel.users) { user in
                let _ = print(user)
                Text(user.displayname)
            }.navigationBarTitle("Friends")
        }.onAppear() {
            self.viewModel.fetchUsers()
        }
    }
}

struct FriendsView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsView()
    }
}
