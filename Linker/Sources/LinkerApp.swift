//
//  LinkerApp.swift
//  Linker
//
//  Created by Anton Heestand on 2022-07-27.
//

import SwiftUI

@main
struct LinkerApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject var auth = AuthServiceManager(service: MainAuthService())
    
    var body: some Scene {
        WindowGroup {
            ContentView(auth: auth)
        }
    }
}
