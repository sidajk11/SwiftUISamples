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
                viewModel.isUpdated.send()
            } label: {
                Text(viewModel.text)
                    .font(.subtitle1)
                    .padding(EdgeInsets(top: 0, leading: padding, bottom: 0, trailing: padding))
            }
            .buttonStyle(.plain)
            .padding(4)
            .offset(x: viewModel.viewOffset.x, y: viewModel.viewOffset.y)
            .simultaneousGesture(
                DragGesture(coordinateSpace: .global)
                    .onChanged { value in
                        viewModel.viewOffset = CGPoint(x: viewModel.lastDragPosition.x + value.translation.width,
                                                       y: viewModel.lastDragPosition.y + value.translation.height)
                    }
                    .onEnded { value in
                        viewModel.lastDragPosition = CGPoint(x: viewModel.viewOffset.x, y: viewModel.viewOffset.y)
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
        
        @Published var viewOffset = CGPoint.zero
        @Published var isMoved: Bool = false
        @Published var lastDragPosition = CGPoint.zero
        
        @Published var frameInGlobal: CGRect = .zero
        @Published var viewOffsetInGlobal: CGPoint = .zero {
            didSet {
                viewOffset = CGPoint(x: viewOffsetInGlobal.x - frameInGlobal.minX - frameInGlobal.width / 2,
                                     y: viewOffsetInGlobal.y - frameInGlobal.minY - frameInGlobal.height / 2)
                lastDragPosition = viewOffset
            }
        }
        
        var isUpdated = PassthroughSubject<Void, Never>()
        
        func onAppear() {
        }
    }
}


#Preview {
    ButtonCell(viewModel: .init(container: .preview))
}
