//
//  ChangeUserView.swift
//  Flashback
//
//  Created by Connie Waffles on 03/08/2024.
//

import SwiftUI
import Firebase

struct ChangeUserView: View {
    @State private var currentUser = Auth.auth().currentUser
    
    @State private var newDisplayName = ""
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        TextField("New  Username", text: $newDisplayName)
            .padding(6.0)
            .background(RoundedRectangle(cornerRadius: 4.0, style: .continuous)
                .stroke(.gray, lineWidth: 1.0))
            .padding()
            .textContentType(.username)
            .autocapitalization(.none)
        
        Button {
            updateDisplayName(name: newDisplayName)
            presentationMode.wrappedValue.dismiss()
        } label: {
            Text("Save")
                .frame(width: 200, height: 40)
                .foregroundColor(.white)
                .background(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
        }
    }
    
    func updateDisplayName(name: String) {
        if name.isValidName {
            let changeRequest = currentUser!.createProfileChangeRequest()
            changeRequest.displayName = name
            changeRequest.commitChanges { error in
                print(error as Any)
            }
            
            print(currentUser?.displayName)
        } else {
            //name not valid
        }
        
        Auth.auth().currentUser?.reload()
    }

}
