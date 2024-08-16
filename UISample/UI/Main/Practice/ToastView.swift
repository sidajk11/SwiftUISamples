//
//  ToastView.swift
//  UISample
//
//  Created by 정영민 on 2024/08/16.
//

import SwiftUI

struct ToastView: View {
    
    @State var size: CGSize = .zero
    
    var body: some View {
        ZStack() {
            VStack {
                Image(.Common.Toast.checkbox)
                    .padding(.top, 10)
                Text("정답!")
                    .foregroundStyle(.appGray600)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 20)
            }
            .background(.appGray200)
            .cornerRadius(8)
            .padding(10)
            .readSize { size in
                self.size = CGSize(width: size.width, height: size.width)
            }
        }
        .frame(width: size.width, height: size.width)
    }
}

#Preview {
    ToastView()
        .border(Color.appGray400)
}
