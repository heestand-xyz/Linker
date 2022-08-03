//
//  ContentView.swift
//  Linker
//
//  Created by Anton Heestand on 2022-07-27.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var auth: AuthServiceManager
    
    @ObservedObject var content: ContentServiceManager
    
    var body: some View {
        
        if auth.authenticated == true {
            
            MainView(auth: auth, content: content)
            
        } else if auth.authenticated == false {
            
            AuthView(auth: auth, content: content)
            
        } else {
            
            NavigationView {
                ProgressView()
                    .navigationTitle("Linker")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(auth: .mocked, content: .mocked)
    }
}
