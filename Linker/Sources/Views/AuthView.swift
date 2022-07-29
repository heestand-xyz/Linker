//
//  AuthView.swift
//  Linker
//
//  Created by Anton Heestand on 2022-07-27.
//

import SwiftUI

struct AuthView: View {
    
    @ObservedObject var auth: AuthServiceManager
    
    private enum ViewState {
        case none
        case signIn
        case signUp
    }
    @State private var viewState: ViewState = .none
    
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""

    @State private var requesting: Bool = false
    @State private var error: Error?

    var body: some View {
        
        NavigationView {
            
            VStack(spacing: 15) {
                
                fields()
                
                info()
                
                buttons()
            }
            .frame(maxWidth: 300)
            .padding(.horizontal)
            .navigationTitle("Welcome to Linker")
        }
    }
    
    private func info() -> some View {
        
        Group {
            
            if requesting {
                ProgressView()
            }
            
            if let error = error {
                Text(error.localizedDescription)
                    .foregroundColor(.red)
            }
        }
    }
    
    private func fields() -> some View {
        
        Group {
            
            if viewState == .signUp {
                
                TextField("Name", text: $name)
            }
            
            if [.signIn, .signUp].contains(viewState) {
                
                TextField("Email", text: $email)
                    .textContentType(.emailAddress)
                    .autocorrectionDisabled()
            }
            
            if [.signIn, .signUp].contains(viewState) {
                
                SecureField("Password", text: $password)
            }
        }
        .disabled(requesting)
    }
    
    private func buttons() -> some View {
        
        Group {
            
            if [.none, .signIn].contains(viewState) {
                signInButton()
            }
            
            if [.none, .signUp].contains(viewState) {
                signUpButton()
            }
            
            if [.signIn, .signUp].contains(viewState) {
                otherButton()
            }
        }
        .disabled(requesting)
    }
    
    private func signInButton() -> some View {
        Button {
            if viewState == .none {
                withAnimation {
                    viewState = .signIn
                }
            } else {
                signIn()
            }
        } label: {
            Text("Sign In")
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .frame(width: viewState == .none ? 200 : nil)
    }
    
    private func signUpButton() -> some View {
        Button {
            if viewState == .none {
                withAnimation {
                    viewState = .signUp
                }
            } else {
                signUp()
            }
        } label: {
            Text("Sign Up")
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)
        .frame(width: viewState == .none ? 200 : nil)
    }
    
    private func otherButton() -> some View {
        Button {
            withAnimation {
                viewState = .none
            }
        } label: {
            Text("Back")
                .font(.footnote)
        }
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
                try await auth.changeName(name)
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
