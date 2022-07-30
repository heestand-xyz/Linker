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

    @State private var editingName: Bool = false
    @State private var name: String = ""

    @State private var photo: UIImage?
    @State private var uploadingPhoto: Bool = false

    @FocusState private var nameFocus: Bool
    
    @State private var error: Error?

    var body: some View {
        
        NavigationView {
            
            VStack(alignment: .leading, spacing: 25) {
                
                Spacer()
                
                PhotoView(image: Binding<UIImage?>(get: {
                    photo
                }, set: { image, _ in
                    guard let image = image else { return }
                    uploadingPhoto = true
                    Task {
                        do {
                            try await auth.changePhoto(image)
                        } catch {
                            failed(with: error)
                        }
                        DispatchQueue.main.async {
                            uploadingPhoto = false
                        }
                    }
                }))
                .frame(width: 150, height: 150)
                .overlay {
                    if uploadingPhoto {
                        ProgressView()
                    }
                }
                .frame(maxWidth: .infinity)
                .onAppear {
                    photo = auth.user?.photo
                }
                .onChange(of: auth.user?.photo) { image in
                    photo = image
                }
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("Name")
                            .bold()
                        Button {
                            if editingName {
                                Task {
                                    do {
                                        try await auth.changeName(name)
                                    } catch {
                                        failed(with: error)
                                    }
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
                                    do {
                                        try await auth.changeName(name)
                                    } catch {
                                        failed(with: error)
                                    }
                                }
                                editingName = false
                            }
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
                
                Spacer()
                Spacer()
            }
            .frame(width: 250)
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
            error != nil
        }, set: { isPresented, _ in
            if !isPresented {
                error = nil
            }
        })) {
            Alert(title: Text("Something went wrong"),
                  message: Text(error?.localizedDescription ?? "Unknown Error"),
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
            error = nil
        }
    }
    
    private func requested() {
        withAnimation {
            requestingSignOut = false
        }
    }
    
    private func failed(with error: Error) {
        withAnimation {
            self.error = error
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(auth: .mocked)
    }
}
