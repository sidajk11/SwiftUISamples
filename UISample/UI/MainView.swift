//
//  MainView.swift
//  UISample
//
//  Created by 정영민 on 2024/06/11.
//

import SwiftUI

struct MainView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var router: Router
    
    var body: some View {
        VStack {
            Text("Hello, World!")
            
            closeButton
        }
        
    }
    
    var closeButton: some View {
        HStack() {
            Button(action: {
                //presentationMode.wrappedValue.dismiss()
                router.popup(2)
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
    MainView()
}
