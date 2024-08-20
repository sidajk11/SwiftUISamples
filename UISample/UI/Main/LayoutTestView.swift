//
//  LayoutTestView.swift
//  UISample
//
//  Created by 정영민 on 2024/08/19.
//

import SwiftUI

struct LayoutTestView: View {
    var body: some View {
        ZStack(alignment: .topLeading) {
            Rectangle()
                .foregroundStyle(.red)
            //.position(popoverFrame.origin)
            //.frame(width: popoverFrame.width, height: popoverFrame.height)
                .offset(CGSize(width: 100, height: 100))
                .background(.blue)
            //.position(CGPoint(x: 150 + 50, y: 150 + 50))
                .offset(CGSize(width: 100, height: 100))
                .background(.green)
                .frame(width: 100, height: 100)
                .offset(CGSize(width: 100, height: 100))
            //.position(CGPoint(x: 150 + 50, y: 150 + 50))
        }
    }
}

#Preview {
    LayoutTestView(viewModel: .preview)
}
