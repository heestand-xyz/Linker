//
//  AddButton.swift
//  Linker
//
//  Created by Anton Heestand on 2022-07-31.
//

import SwiftUI

struct AddButton: View {
    
    let action: () -> ()
    
    var body: some View {
        
        Button {
            action()
        } label: {
            Image(systemName: "plus")
                .font(.system(size: 25, weight: .semibold, design: .default))
                .foregroundColor(.white)
                .padding(15)
                .background {
                    Circle()
                        .foregroundColor(.accentColor)
                        .shadow(radius: 10)
                }
        }
    }
}

struct AddButton_Previews: PreviewProvider {
    static var previews: some View {
        AddButton(action: {})
    }
}
