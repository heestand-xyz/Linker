//
//  LinkView.swift
//  Linker
//
//  Created by Anton Heestand on 2022-07-27.
//

import SwiftUI
import LinkPresentation

struct LinkView: UIViewRepresentable {
    
    let url: URL
    
    func makeUIView(context: Context) -> LPLinkView {
        let linkView = LPLinkView(url: url)
        context.coordinator.metadataCallback = { metadata in
            linkView.metadata = metadata
        }
        return linkView
    }
    
    func updateUIView(_ linkView: LPLinkView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(url: url)
    }
    
    class Coordinator {
        
        let metadataProvider: LPMetadataProvider
        
        var metadataCallback: ((LPLinkMetadata) -> ())?
        
        init(url: URL) {
            
            metadataProvider = LPMetadataProvider()
            
            metadataProvider.startFetchingMetadata(for: url) { [weak self] metadata, error in

                guard error == nil,
                      let metadata = metadata else {
                    return
                }
                
                DispatchQueue.main.async {

                    self?.metadataCallback?(metadata)
                }
            }
        }
    }
}

struct LinkView_Previews: PreviewProvider {
    static var previews: some View {
        LinkView(url: URL(string: "https://www.theverge.com/2022/6/26/23183777/apple-mixed-reality-headset-m2-chip-rumors-virtual-reality-ar")!)
            .padding()
            .previewLayout(.fixed(width: 300, height: 300))
    }
}
