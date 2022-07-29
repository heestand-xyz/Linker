//
//  SettingsView.swift
//  Linker
//
//  Created by Anton Heestand on 2022-07-27.
//

import SwiftUI

struct SettingsView: View {
    
    @ObservedObject var auth: AuthServiceManager
    
    @State private var requestingSignOut: Bool = false
    @State private var signOutError: Error?

    @State private var editingName: Bool = false
    @State private var name: String = ""
    
    @FocusState private var nameFocus: Bool

    var body: some View {
        
        NavigationView {
            
            VStack(alignment: .leading, spacing: 25) {
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("Name")
                            .bold()
                        Button {
                            if editingName {
                                Task {
                                    try? await auth.changeName(name)
                                }
                            }
                            editingName.toggle()
                            nameFocus = true
                        } label: {
                            Image(systemName: "pencil.circle")
                                .symbolVariant(editingName ? .fill : .none)
                        }
                    }
                    if editingName {
                        TextField("Name", text: $name)
                            .onSubmit {
                                Task {
                                    try? await auth.changeName(name)
                                }
                                editingName = false
                            }
                            .frame(width: 150)
                            .focused($nameFocus)
                    } else {
                        if let name = auth.user?.name {
                            Text(name)
                                .opacity(0.75)
                        } else {
                            Text("-")
                                .opacity(0.5)
                        }
                    }
                }
                .onAppear {
                    name = auth.user?.name ?? ""
                }
                
                VStack(alignment: .leading) {
                    Text("Email")
                        .bold()
                    if let email = auth.user?.email {
                        Text(email)
                            .opacity(0.75)
                    }
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    if requestingSignOut {
                        ProgressView()
                    } else {
                        Button {
                            signOut()
                        } label: {
                            Text("Sign Out")
                        }
                        .disabled(requestingSignOut)
                    }
                }
            }
        }
        .alert(isPresented: Binding<Bool>(get: {
            signOutError != nil
        }, set: { isPresented, _ in
            if !isPresented {
                signOutError = nil
            }
        })) {
            Alert(title: Text("Sign Out Error"),
                  message: Text(signOutError?.localizedDescription ?? "Unknown Error"),
                  dismissButton: .default(Text("Ok")))
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
            requestingSignOut = true
            signOutError = nil
        }
    }
    
    private func requested() {
        withAnimation {
            requestingSignOut = false
        }
    }
    
    private func failed(with error: Error) {
        withAnimation {
            signOutError = error
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(auth: .mocked)
    }
}
