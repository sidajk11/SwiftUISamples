//
//  AnswerTextCell.swift
//  UISample
//
//  Created by 정영민 on 2024/08/12.
//

import SwiftUI
import Combine

struct ButtonCell: View {
    @StateObject var viewModel: ViewModel
    
    private let padding: CGFloat = 0
    
    var body: some View {
        content
            .onAppear {
                self.viewModel.onAppear()
            }
            .readSize { size in
                print("\(viewModel.text) \(size.width)")
            }
    }
    
    var content: some View {
        ZStack {
            Button {
                print(viewModel.text)
                viewModel.isMoved.toggle()
                viewModel.action?()
            } label: {
                Text(viewModel.text)
                    .font(.subtitle1)
                    .padding(EdgeInsets(top: 0, leading: padding, bottom: 0, trailing: padding))
            }
            .buttonStyle(.plain)
            .padding(4)
            .offset(x: viewModel.viewOffset.x + viewModel.translation.width, y: viewModel.viewOffset.y + viewModel.translation.height)
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
        }
    }
}


#Preview {
    ButtonCell(viewModel: .init(container: .preview))
}
