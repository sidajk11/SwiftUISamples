//
//  PresentingView.swift
//  UISample
//
//  Created by 정영민 on 2024/06/12.
//

import SwiftUI

struct PresentingView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            VStack {
                closeButton
                Spacer()
            }
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }
    }
    
    var closeButton: some View {
        HStack() {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
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
    PresentingView()
}
