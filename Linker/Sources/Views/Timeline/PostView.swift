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
        
        VStack(alignment: .leading) {
            
            Text(post.text)
            
            LinkView(url: post.url)
            
            HStack {
                Spacer()
                Text("by \(post.user.name)")
                    .opacity(0.5)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView(post: .mocked)
    }
}
