//
//  TimelineView.swift
//  Linker
//
//  Created by Anton Heestand on 2022-07-29.
//

import SwiftUI

struct TimelineView: View {
   
    @ObservedObject var auth: AuthServiceManager
    @ObservedObject var content: ContentServiceManager

    @State private var composing: Bool = false
    
    var body: some View {
    
        NavigationView {
            
            ZStack(alignment: .bottomTrailing) {
                
                ScrollView {
                    
                    VStack {
                        
                        let posts: [Post] = content.posts.sorted(by: { leadingPost, trailingPost in
                            leadingPost.date > trailingPost.date
                        })
                        
                        ForEach(posts) { post in
                            
                            PostView(post: post)
                            
                            Divider()
                        }
                    }
                }
                .navigationTitle("Timeline")
                
                AddButton {
                    composing = true
                }
                .padding(20)
            }
        }
        .sheet(isPresented: $composing) {
            ComposeView(auth: auth, content: content)
        }
    }
}

struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        TimelineView(auth: .mocked, content: .mocked)
    }
}
