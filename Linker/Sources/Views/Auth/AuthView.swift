//
//  AuthView.swift
//  Linker
//
//  Created by Anton Heestand on 2022-07-27.
//

import SwiftUI

struct AuthView: View {
    
    @ObservedObject var auth: AuthServiceManager
    
    @State private var email: String = ""
    @State private var password: String = ""
    
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
            
            Group {
                
                TextField("Email", text: $email)
                
                TextField("Password", text: $password)
            }
            .disabled(requesting)
            
            Group {
                
                Button {
                    signIn()
                } label: {
                    Text("Sign In")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                
                Button {
                    signUp()
                } label: {
                    Text("Sign Up")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                
                Button {
                    resetPassword()
                } label: {
                    Text("Forgot password")
                        .frame(maxWidth: .infinity)
                }
            }
            .disabled(requesting)
        }
        .padding(.horizontal)
    }
    
    private func signIn() {
        request()
        Task {
            do {
                try await auth.signIn(email: email, password: password)
            } catch {
                failed(with: error)
            }
            requested()
        }
    }
    
    private func signUp() {
        request()
        Task {
            do {
                try await auth.signUp(email: email, password: password)
            } catch {
                failed(with: error)
            }
            requested()
        }
    }
    
    private func resetPassword() {
        request()
        Task {
            do {
                try await auth.resetPassword(email: email)
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

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView(auth: .mocked)
    }
}
