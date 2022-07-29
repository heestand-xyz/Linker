//
//  TimelineView.swift
//  Linker
//
//  Created by Anton Heestand on 2022-07-29.
//

import SwiftUI

struct TimelineView: View {
    
    var body: some View {
    
        NavigationView {
            
            Text("Timeline")
                .navigationTitle("Linker")
        }
    }
}

struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        TimelineView()
    }
}
