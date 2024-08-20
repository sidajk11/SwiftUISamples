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
            .overlay(contentAlignmentGuide)
        //content
    }
    
    var contentAlignmentGuide: some View {
        ZStack() {
            Rectangle()
                .foregroundStyle(.appBlue500)
                .frame(width: 50, height: 50)
                .alignmentGuide(VerticalAlignment.center, computeValue: { dimension in
                    25+150
                })
                .alignmentGuide(HorizontalAlignment.center, computeValue: { dimension in
                    25
                })
            
            Rectangle()
                .foregroundStyle(.appBlue500)
                .frame(width: 200, height: 200)
                .offset(x: 200, y: 200)
        }
        .border(.green)
    }
    
    var content: some View {
        ZStack(alignment: .center) {
            Rectangle()
                .foregroundStyle(.appBlue500)
            //.position(popoverFrame.origin)
            //.frame(width: popoverFrame.width, height: popoverFrame.height)
//                .offset(CGSize(width: 10, height: 0))
//                .background(.blue)
//                .position(CGPoint(x: 150 + 50, y: 150 + 50))
//                .offset(CGSize(width: 10, height: 0))
//                .background(.green)
                .frame(width: 300, height: 300)
                .offset(CGSize(width: 10, height: 0))
                .position(CGPoint(x: 200, y: 250))
            
            Rectangle()
                .foregroundStyle(.appBlue300)
                .frame(width: 140, height: 140)
                .position(CGPointMake(100, 120))
        }
        .border(.green)
    }
}

#Preview {
    LayoutTestView()
}
