//
//  MainView.swift
//  Linker
//
//  Created by Anton Heestand on 2022-07-27.
//

import SwiftUI

struct MainView: View {
    
    @ObservedObject var auth: AuthServiceManager
    
    @ObservedObject var content: ContentServiceManager
    
    @State private var requesting: Bool = false
    @State private var error: Error?

    var body: some View {
        
        TabView {
            
            TimelineView(content: content)
                .tabItem {
                    Label {
                        Text("Timeline")
                    } icon: {
                        Image(systemName: "newspaper")
                    }
                }
            
            AccountView(auth: auth)
                .tabItem {
                    Label {
                        Text("Account")
                    } icon: {
                        Image(systemName: "person")
                    }
                }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(auth: .mocked, content: .mocked)
    }
}
