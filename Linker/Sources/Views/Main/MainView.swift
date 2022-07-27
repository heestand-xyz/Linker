//
//  MainView.swift
//  Linker
//
//  Created by Anton Heestand on 2022-07-27.
//

import SwiftUI

struct MainView: View {
    
    @ObservedObject var auth: AuthServiceManager
    
    @State private var requesting: Bool = false
    @State private var error: Error?

    var body: some View {
        
        VStack(spacing: 15) {
            
            if requesting {
                HStack(spacing: 15) {
                    ProgressView()
                    Text("Loading...")
                        .opacity(0.5)
                }
            }
            
            if let error = error {
                Text(error.localizedDescription)
                    .foregroundColor(.red)
            }
            
            Button {
                signOut()
            } label: {
                Text("Sign Out")
            }
            .disabled(requesting)
        }
    }
    
    private func signOut() {
        
        request()
        
        Task {
            do {
                try await auth.signOut()
            } catch {
                failed(with: error)
            }
            requested()
        }
    }
    
    private func request() {
        withAnimation {
            requesting = true
            error = nil
        }
    }
    
    private func requested() {
        withAnimation {
            requesting = false
        }
    }
    
    private func failed(with error: Error) {
        withAnimation {
            self.error = error
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(auth: .mocked)
    }
}
