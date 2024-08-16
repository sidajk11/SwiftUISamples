//
//  ToastView.swift
//  UISample
//
//  Created by 정영민 on 2024/08/16.
//

import SwiftUI

struct ToastView: View {
    
    @State var size: CGSize?
    
    var body: some View {
        ZStack() {
            VStack {
                Image(.Common.Toast.checkbox)
                    .padding(.top, 10)
                Text("정답!")
                    .foregroundColor(.appGray600)
                    .padding(.horizontal, 10)
                    .padding(.bottom, 20)
            }
            .padding(10)
            .readSize { size in
                self.size = CGSize(width: size.width, height: size.width)
            }
        }
        .frame(width: size?.width, height: size?.width)
        .frame(minWidth: 120, minHeight: 120)
        .background(.appGray200)
        .cornerRadius(8)
    }
}

#Preview {
    ToastView()
        .border(Color.appGray400)
}
