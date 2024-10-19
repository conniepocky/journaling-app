//
//  ImageLoader.swift
//  Flashback
//
//  Created by Connie Waffles on 13/10/2024.
//

import FirebaseStorage
import SwiftUI
import Foundation

class ImageLoader: ObservableObject {
    @Published var image: UIImage?

    func loadImage(postID: String) {
        let storageRef = Storage.storage().reference().child("\(postID).jpg")

        storageRef.getData(maxSize: 2 * 1024 * 1024) { data, error in
            if let error = error {
                print("Error downloading image: \(error)")
                return
            }
            if let data = data, let uiImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = uiImage
                }
            }
        }
    }
}
