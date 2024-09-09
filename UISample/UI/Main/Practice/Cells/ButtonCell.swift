//
//  AnswerTextCell.swift
//  UISample
//
//  Created by 정영민 on 2024/08/12.
//

import SwiftUI
import Combine

struct ButtonCell: View {
    @ObservedObject var viewModel: ViewModel
    
    @State private var animation: Bool = false
    
    private let padding: CGFloat = 10
    
    var body: some View {
        content
            .onAppear {
                self.viewModel.onAppear()
            }
    }
    
    var content: some View {
        ZStack {
            Text(viewModel.text)
                .font(.subtitle1)
                .padding(EdgeInsets(top: 4, leading: padding, bottom: 4, trailing: padding))
                .background(.appGray200)
                .cornerRadius(12)
                .onTapGesture {
                    animation = true
                    viewModel.isMoved.toggle()
                    viewModel.action?()
                }
            .offset(x: viewModel.viewOffset.x + viewModel.translation.width, y: viewModel.viewOffset.y + viewModel.translation.height)
            .animation(animation ? .easeInOut(duration: 0.25) : nil, value: UUID())
            .simultaneousGesture(
                DragGesture()
                    .onChanged { value in
                        viewModel.translation = value.translation
                    }
                    .onEnded { value in
                        viewModel.translation = .zero
                        viewModel.viewOffset = CGPoint(x: viewModel.viewOffset.x + viewModel.translation.width, y: viewModel.viewOffset.y + viewModel.translation.height)
                    }
            )
            .readFrameInGlobal { frame in
                viewModel.frameInGlobal = frame
            }
        }
    }
}

extension ButtonCell {
    class ViewModel: BaseViewModel {
        var text: String = ""
        var index: Int = 0
        
        var action: Callback?
        
        @Published var viewOffset = CGPoint.zero
        @Published var isMoved: Bool = false
        @Published var translation: CGSize = .zero
        
        @Published var frameInGlobal: CGRect = .zero
        @Published var viewOffsetInGlobal: CGPoint = .zero {
            didSet {
                viewOffset = CGPoint(x: viewOffsetInGlobal.x - frameInGlobal.minX - frameInGlobal.width / 2,
                                     y: viewOffsetInGlobal.y - frameInGlobal.minY - frameInGlobal.height / 2)
            }
        }
        
        func onAppear() {
            isAppeared = true
        }
    }
}


#Preview {
    ButtonCell(viewModel: .init(container: .preview))
}
