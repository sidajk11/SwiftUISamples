//
//  AnswerTextCell.swift
//  EnPractice
//
//  Created by 정영민 on 2024/08/12.
//

import SwiftUI
import Combine

struct ButtonCell: View {
    let data: CellData
    let actionTap: () -> Void
    
    @State private var animation: Bool = false
    @State var viewOffset = CGPoint.zero
    @State var isMoved: Bool = false
    @State var translation: CGSize = .zero
    
    @State var frameInGlobal: CGRect = .zero
    @State var viewOffsetInGlobal: CGPoint = .zero {
        didSet {
            viewOffset = CGPoint(x: viewOffsetInGlobal.x - frameInGlobal.minX - frameInGlobal.width / 2,
                                 y: viewOffsetInGlobal.y - frameInGlobal.minY - frameInGlobal.height / 2)
        }
    }
    
    private let padding: CGFloat = 10
    
    var body: some View {
        content
    }
    
    var content: some View {
        ZStack {
            Text(data.text)
                .font(.subtitle1)
                .padding(EdgeInsets(top: 4, leading: padding, bottom: 4, trailing: padding))
                .background(.appGray200)
                .cornerRadius(12)
                .onTapGesture {
                    animation = true
                    isMoved.toggle()
                    actionTap()
                }
            .offset(x: viewOffset.x + translation.width, y: viewOffset.y + translation.height)
            .animation(animation ? .easeInOut(duration: 0.25) : nil, value: UUID())
            .simultaneousGesture(
                DragGesture()
                    .onChanged { value in
                        translation = value.translation
                    }
                    .onEnded { value in
                        translation = .zero
                        viewOffset = CGPoint(x: viewOffset.x + translation.width, y: viewOffset.y + translation.height)
                    }
            )
            .readFrameInGlobal { frame in
                frameInGlobal = frame
            }
        }
    }
}

extension ButtonCell {
    struct CellData: Identifiable {
        let id: UUID = UUID()
        
        let text: String
        let index: Int
    }
}


#Preview {
    ButtonCell(data: ButtonCell.CellData(text: "", index: 0), actionTap: {})
}
