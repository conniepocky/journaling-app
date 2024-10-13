//
//  PostView.swift
//  Flashback
//
//  Created by Connie Waffles on 13/10/2024.
//

import SwiftUI
import Firebase
import PhotosUI

struct PostView: View {
    let post: Posts
    @StateObject private var imageLoader = ImageLoader()

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(post.author)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.accentColor)

                Spacer()

                Text(post.date_time)
                    .font(.footnote)
                    .foregroundColor(.gray)
            }

            if let image = imageLoader.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .cornerRadius(10)
                    .padding(.bottom, 10)
            }

            Text(post.text)
                .font(.body)
                .foregroundColor(.primary)
                .lineLimit(nil)
                .multilineTextAlignment(.leading)

            Divider()
        }
        .onAppear {
            imageLoader.loadImage(postID: post.id) // Load image using post ID
        }
    }
}
