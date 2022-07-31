//
//  ComposeView.swift
//  Linker
//
//  Created by Anton Heestand on 2022-07-31.
//

import SwiftUI

struct ComposeView: View {

    @Environment(\.presentationMode) private var presentationMode
    
    @ObservedObject var auth: AuthServiceManager
    @ObservedObject var content: ContentServiceManager
    
    @State private var text: String = ""
    
    @State private var link: String = ""
    var formattedLink: String {
        guard link != "" else { return "" }
        guard link.contains(".") else { return "" }
        if link.starts(with: "http") {
            return link
        } else {
            return "http://\(link)"
        }
    }
    @State private var validLink: Bool = false
    
    @State private var requesting: Bool = false
    
    @State private var error: Error?

    var body: some View {
        
        NavigationView {
            
            VStack {
                
                TextField("Description", text: $text)
                    .disabled(requesting)
                
                TextField("Link", text: $link)
                    .textContentType(.URL)
                    .disableAutocorrection(true)
                    .disabled(requesting)
                    .onChange(of: link, perform: { link in
                        self.link = link.lowercased()
                    })
                    .onChange(of: formattedLink) { link in
                        validLink = {
                            guard let url = URL(string: link) else { return false }
                            return UIApplication.shared.canOpenURL(url)
                        }()
                    }
                
                if validLink, let url = URL(string: formattedLink) {
                    LinkView(url: url)
                        .id(url)
                        .frame(height: 250)
                } else if link != "" {
                    Text("Link is not valid")
                        .foregroundColor(.red)
                }
                
                if requesting {
                    ProgressView()
                        .padding()
                }
                
                Button {
                    createPost()
                } label: {
                    Text("Post Link")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .disabled(requesting)
                
            }
            .padding()
            .navigationTitle("New Link")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Cancel")
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
    
    enum CreatePostError: Error {
        case notAuthorized
        case badLink
    }
    
    private func createPost() {
        
        guard let user = auth.user else {
            failed(with: CreatePostError.notAuthorized)
            return
        }
        
        guard let url = URL(string: formattedLink) else {
            failed(with: CreatePostError.badLink)
            return
        }
        
        let postUser = Post.User(name: user.name ?? "Unknown", id: user.id)
        let post = Post(user: postUser, url: url, text: text)
        
        withAnimation {
            requesting = true
        }
        
        Task {
            do {
                try await content.create(post: post)
                presentationMode.wrappedValue.dismiss()
            } catch {
                failed(with: error)
            }
            withAnimation {
                requesting = false
            }
        }
    }
    
    private func failed(with error: Error) {
        withAnimation {
            self.error = error
        }
    }
}

struct ComposeView_Previews: PreviewProvider {
    static var previews: some View {
        ComposeView(auth: .mocked, content: .mocked)
    }
}
