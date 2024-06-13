//
//  CloseButton.swift
//  UISample
//
//  Created by 정영민 on 2024/06/13.
//

import SwiftUI

struct CloseButton: View {
    private var action: () -> Void
    
    init(action: @escaping () -> Void) {
        self.action = action
    }
    var body: some View {
        HStack() {
            Button(action: {
                //presentationMode.wrappedValue.dismiss()
                action()
            }) {
                Image(systemName: "xmark")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.gray.opacity(0.6))
                    .clipShape(Circle())
            }
            .padding()
            Spacer()
        }
    }
}

#Preview {
    CloseButton(action: {})
}
