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
            
            ZStack {
                
                List {
                       
                    let posts: [Post] = content.posts.sorted(by: { leadingPost, trailingPost in
                        leadingPost.date > trailingPost.date
                    })
                    
                    ForEach(posts) { post in
                        
                        PostView(auth: auth, content: content, post: post)
                    }
                }
                .listStyle(.plain)
                .refreshable {
                    try? await content.refresh()
                }
                
                AddButton {
                    composing = true
                }
                .padding(20)
                .frame(maxWidth: .infinity,
                       maxHeight: .infinity,
                       alignment: .bottomTrailing)
            }
            .navigationTitle("Linker")
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
