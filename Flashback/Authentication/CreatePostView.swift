//
//  CreatePostView.swift
//  Flashback
//
//  Created by Connie Waffles on 10/08/2023.
//

import SwiftUI
import Firebase

struct CreatePostView: View {
    
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.presentationMode) var presentationMode
    
    @State private var text = ""
    var currentUser = Auth.auth().currentUser!
    
    var body: some View {
        VStack {
            if dataManager.prompts.count > 0 { Text(dataManager.prompts[0].text)
                    .foregroundColor(.accentColor)
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .padding()
            }
        }
        
        TextField("Reply..", text: $text, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .lineLimit(5, reservesSpace: true)
                        .padding()
        
        Button {
            dataManager.addPost(text: text)
            presentationMode.wrappedValue.dismiss()
        } label: {
            Text("Post")
                .frame(width: 200, height: 40)
                .foregroundColor(.white)
                .background(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
        }
        
        
        Spacer()
    }
}

struct CreatePostView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePostView()
    }
}
