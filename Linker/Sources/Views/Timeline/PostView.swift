//
//  PostView.swift
//  Linker
//
//  Created by Anton Heestand on 2022-07-30.
//

import SwiftUI

struct PostView: View {
    
    @ObservedObject var auth: AuthServiceManager
    @ObservedObject var content: ContentServiceManager
    
    let post: Post
    
    @State private var showDeletionConfirmation: Bool = false
    
    @State private var error: Error?
    
    private var isAuthor: Bool {
        auth.user?.id == post.user.id
    }

    var body: some View {
        
        VStack(alignment: .leading) {
            
            Text(post.text)
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 4)
            
            LinkView(url: post.url)
            
            HStack {

                Text(post.date, format: .dateTime)

                Spacer()

                Text("by \(post.user.name)")

                if isAuthor {

                    Button {
                        showDeletionConfirmation = true
                    } label: {
                        Image(systemName: "trash")
                    }
                    .buttonStyle(.borderless)
                    .foregroundColor(.red)
                }
            }
            .font(.footnote)
            .padding(.horizontal, 4)
            .opacity(0.5)
        }
        .padding(.vertical, 10)
        .padding(.trailing, 15)
        .frame(maxWidth: .infinity, alignment: .leading)
        .actionSheet(isPresented: $showDeletionConfirmation, content: {
            ActionSheet(title: Text("Delete Post"), message: Text(post.text), buttons: [
                .destructive(Text("Delete"), action: {
                    deletePost()
                }),
                .cancel()
            ])
        })
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
    
    private func deletePost() {
        Task {
            do {
                try await content.delete(post: post)
            } catch {
                failed(with: error)
            }
        }
    }
    
    private func failed(with error: Error) {
        withAnimation {
            self.error = error
        }
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView(auth: .mocked, content: .mocked, post: .mocked)
    }
}
