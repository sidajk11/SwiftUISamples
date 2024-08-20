//
//  LayoutTestView.swift
//  UISample
//
//  Created by 정영민 on 2024/08/19.
//

import SwiftUI

struct LayoutTestView: View {
    var body: some View {
        Rectangle()
            .foregroundStyle(.appGray300)
            .overlay(content)
        //content
    }
    
    var content: some View {
        ZStack(alignment: .center) {
            Rectangle()
                .fill(.red)
                .foregroundStyle(.red)
            //.position(popoverFrame.origin)
            //.frame(width: popoverFrame.width, height: popoverFrame.height)
//                .offset(CGSize(width: 10, height: 0))
//                .background(.blue)
//                .position(CGPoint(x: 150 + 50, y: 150 + 50))
//                .offset(CGSize(width: 10, height: 0))
//                .background(.green)
                .frame(width: 300, height: 300)
                .offset(CGSize(width: 0, height: 0))
                //.position(CGPoint(x: 50, y: 50))
            
            Rectangle()
                .foregroundStyle(.yellow)
                .frame(width: 140, height: 140)
        }
    }
}

#Preview {
    LayoutTestView()
}
