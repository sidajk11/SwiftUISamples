//
//  ToastModifier.swift
//  UISample
//
//  Created by 정영민 on 2024/08/16.
//

import SwiftUI

struct ToastModifier: ViewModifier {

    @Binding var isShow: Bool
    func body(content: Content) -> some View {
        content
            .overlay {
                ZStack {
                    mainView()
                }
            }
    }
    
    @ViewBuilder func mainView() -> some View {
        if isShow {
            ToastView()
        }
    }
}

extension View {
    func toastView(isShow: Binding<Bool>) -> some View {
        modifier(ToastModifier(isShow: isShow))
    }
}
