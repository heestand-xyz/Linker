//
//  ContentView.swift
//  Linker
//
//  Created by Anton Heestand on 2022-07-27.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var auth: AuthServiceManager
    
    var body: some View {
        
        if auth.authenticated == true {
            
            MainView(auth: auth)
            
        } else if auth.authenticated == false {
            
            AuthView(auth: auth)
            
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
        ContentView(auth: .mocked)
    }
}
