//
//  CreatePostView.swift
//  Flashback
//
//  Created by Connie Waffles on 10/08/2023.
//

import SwiftUI
import Firebase
import PhotosUI

struct CreatePostView: View {
    
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.presentationMode) var presentationMode
    
    @State private var text = ""
    var currentUser = Auth.auth().currentUser!
    
    @State var data: Data?
    @State var selectedItem: [PhotosPickerItem] = []
    
    var body: some View {
        VStack {
            if dataManager.prompts.count > 0 { Text(dataManager.prompts[0].text)
                    .foregroundColor(.accentColor)
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .padding()
            }
        }
        
        PhotosPicker(selection: $selectedItem, maxSelectionCount: 1, selectionBehavior: .default, matching: .images, preferredItemEncoding: .automatic) {
            if let data = data, let image = UIImage(data: data) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame( maxHeight: 300)
            } else {
                Label("Select a picture", systemImage: "photo.on.rectangle.angled")
            }
        }.onChange(of: selectedItem) { newValue in
            guard let item = selectedItem.first else {
                return
            }
            item.loadTransferable(type: Data.self) { result in
                switch result {
                case .success(let data):
                    if let data = data {
                        self.data = data
                    }
                case .failure(let failure):
                    print("Error: \(failure.localizedDescription)")
                }
            }
        }
        
        TextField("Reply..", text: $text, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .lineLimit(5, reservesSpace: true)
                        .padding()
        
        Button {
            dataManager.addPost(text: text, data: data)
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
