//
//  BlurView.swift
//  EnPractice
//
//  Created by 정영민 on 2024/05/31.
//


import Foundation
import SwiftUI

@available(iOS 13, *)
public struct BlurView: UIViewRepresentable {
    public typealias UIViewType = UIVisualEffectView
    
    public func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
    }
    
    public func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: .systemMaterial)
    }
}
