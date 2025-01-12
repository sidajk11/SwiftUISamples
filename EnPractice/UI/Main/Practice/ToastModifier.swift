//
//  ToastModifier.swift
//  EnPractice
//
//  Created by 정영민 on 2024/08/16.
//

import SwiftUI

struct ToastModifier: ViewModifier {

    @Binding var isShow: Bool
    @State var opacity: CGFloat = 0
    @State var animated: Bool = false
    
    func body(content: Content) -> some View {
        content
            .overlay {
                ZStack {
                    mainView()
                        .fadeTransition(isVisible: isShow, duration: 0.25)
                }
            }
            .onChange(of: isShow) { value in
                if isShow {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        isShow = false
                    }
                }
            }
            .animation(.default, value: 1)
    }
    
    @ViewBuilder func mainView() -> some View {
        //if isShow {
            ToastView()
        //}
    }
}

extension View {
    func toastView(isShow: Binding<Bool>) -> some View {
        modifier(ToastModifier(isShow: isShow))
    }
}
