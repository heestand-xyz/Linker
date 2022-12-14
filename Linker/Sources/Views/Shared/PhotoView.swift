//
//  PhotoView.swift
//  Linker
//
//  Created by Anton Heestand on 2022-07-30.
//

import SwiftUI

struct PhotoView: View {
    
    @Binding var image: UIImage?
    
    @State private var showPicker: Bool = false
    @State private var showCameraPicker: Bool = false
    @State private var showPhotoPicker: Bool = false
    
    var body: some View {
        
        Button {
            
            showPicker = true
            
        } label: {
                
            if let image: UIImage = image {
                
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
                
            } else {
                
                GeometryReader { geometry in
                    ZStack {
                        Circle()
                            .opacity(0.1)
                        Image(systemName: "person.fill")
                            .font(.system(size: geometry.size.height * 0.6))
                    }
                }
                .foregroundColor(.accentColor)
            }
        }
        .aspectRatio(1.0, contentMode: .fit)
        .actionSheet(isPresented: $showPicker) {
            ActionSheet(title: Text("Profile Photo"), buttons: {
                var buttons: [ActionSheet.Button] = []
                buttons.append(.default(Text("Photos"), action: {
                    showPhotoPicker = true
                }))
                #if !targetEnvironment(simulator)
                buttons.append(.default(Text("Camera"), action: {
                    showCameraPicker = true
                }))
                #endif
                buttons.append(.cancel())
                return buttons
            }())
        }
        .sheet(isPresented: $showPhotoPicker) {
            PhotoPickerView(sourceType: .photoLibrary, selectedImage: $image)
        }
        .fullScreenCover(isPresented: $showCameraPicker) {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                PhotoPickerView(sourceType: .camera, selectedImage: $image)
            }
        }
    }
}

struct PhotoView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoView(image: .constant(nil))
            .padding()
    }
}
