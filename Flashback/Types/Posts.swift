//
//  Posts.swift
//  Flashback
//
//  Created by Connie Waffles on 07/08/2023.
//

import SwiftUI

struct Posts: Identifiable {
    var id: String
    var prompt: String
    var text: String
    var author: String
    var author_id: String
    var date_time: String
    var image: Bool
    var likes: [String]
}
