//
//  ActivityIndicator.swift
//  UISample
//
//  Created by 정영민 on 2024/05/31.
//

import SwiftUI

@available(iOS 13, *)
struct ActivityIndicator: UIViewRepresentable {

    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        
        let progressView = UIActivityIndicatorView(style: .large)
        progressView.startAnimating()
        
        return progressView
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
    }
}

