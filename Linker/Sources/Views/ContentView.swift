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
        
        if auth.authenticated {
            
            MainView(auth: auth)
            
        } else {
            
            AuthView(auth: auth)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(auth: .mocked)
    }
}
