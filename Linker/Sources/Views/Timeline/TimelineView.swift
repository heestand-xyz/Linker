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
            
            ScrollView {
                VStack {
                    ForEach(content.posts) { post in
                        PostView(post: post)
                        Divider()
                    }
                }
            }
            .navigationTitle("Timeline")
        }
    }
}

struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        TimelineView(content: .mocked)
    }
}
