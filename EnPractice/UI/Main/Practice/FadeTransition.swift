//
//  FadeTransition.swift
//  EnPractice
//
//  Created by 정영민 on 2024/08/16.
//

import SwiftUI

struct FadeTransition: ViewModifier {
    let isVisible: Bool
    let duration: Double

    func body(content: Content) -> some View {
        content
            .opacity(isVisible ? 1 : 0)
            .scaleEffect(isVisible ? 1 : 1.08)
            .animation(.easeInOut(duration: duration), value: isVisible)
    }
}

extension View {
    func fadeTransition(isVisible: Bool, duration: Double = 0.25) -> some View {
        self.modifier(FadeTransition(isVisible: isVisible, duration: duration))
    }
}
