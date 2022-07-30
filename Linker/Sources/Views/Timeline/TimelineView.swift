//
//  TimelineView.swift
//  Linker
//
//  Created by Anton Heestand on 2022-07-29.
//

import SwiftUI

struct TimelineView: View {
   
    @ObservedObject var content: ContentServiceManager

    var body: some View {
    
        NavigationView {
            
            List {
                ForEach(content.posts) { post in
                    PostView(post: post)
                }
            }
            .navigationTitle("Linker")
        }
    }
}

struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        TimelineView(content: .mocked)
    }
}
