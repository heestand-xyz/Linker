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
    
    @State private var photo: UIImage?
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""

    @State private var requesting: Bool = false
    @State private var error: Error?

    var body: some View {
        
        NavigationView {
            
            VStack(spacing: 15) {
                
                Spacer()
                    .frame(height: 50)
                
                if viewState == .none {
                    
                    Image(systemName: "link")
                        .font(.system(size: 100))
                        .foregroundColor(.accentColor)
                        .frame(height: 100)
                    
                    Text("Share Links")
                        .bold()
                        .foregroundColor(.accentColor)
                }
                
                Spacer()
                
                fields()
                
                info()
                
                buttons()
                
                Spacer()
                Spacer()
                
                Text("Created by Anton Heestand")
                    .font(.footnote)
                    .opacity(0.25)
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
                
                PhotoView(image: $photo)
                    .frame(width: 100, height: 100)

                TextField("Name", text: $name)
            }
            
            if [.signIn, .signUp].contains(viewState) {
                
                TextField("Email", text: $email)
                    .textContentType(.emailAddress)
                    .disableAutocorrection(true)
                    .onChange(of: email, perform: { email in
                        self.email = email.lowercased()
                    })
                
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
            clear()
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
                if name != "" {
                    try await auth.changeName(name)
                }
                if let photo: UIImage = photo {
                    try await auth.changePhoto(photo)
                }
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
    
    private func clear() {
        withAnimation {
            error = nil
        }
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView(auth: .mocked)
    }
}
