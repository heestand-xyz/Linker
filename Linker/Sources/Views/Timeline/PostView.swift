//
//  PostView.swift
//  Linker
//
//  Created by Anton Heestand on 2022-07-30.
//

import SwiftUI

struct PostView: View {
    
    let post: Post
    
    var body: some View {
        Text(post.text)
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView(post: .mocked)
    }
}
