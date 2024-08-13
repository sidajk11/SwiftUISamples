//
//  AnswerTextCell.swift
//  UISample
//
//  Created by 정영민 on 2024/08/12.
//

import SwiftUI

struct ButtonCell: View {
    let viewModel: ViewModel
    
    private let padding: CGFloat = 0
    
    @State var isMoved: Bool = false
    
    @State private var viewOffset = CGSize.zero
    @State private var lastDragPosition = CGSize.zero
    
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
                isMoved.toggle()
            } label: {
                Text(viewModel.text)
                    .font(.subtitle1)
                    .padding(EdgeInsets(top: 0, leading: padding, bottom: 0, trailing: padding))
            }
            .buttonStyle(.plain)
            .clipShape(.rect(cornerRadii: .init(topLeading: 2, bottomLeading: 2, bottomTrailing: 2, topTrailing: 2)))
            .padding(4)
            .offset(x: viewOffset.width, y: viewOffset.height)
            .simultaneousGesture(
                DragGesture()
                    .onChanged { value in
                        viewOffset = CGSize(width: lastDragPosition.width + value.translation.width,
                                            height: lastDragPosition.height + value.translation.height)
                    }
                    .onEnded { value in
                        lastDragPosition = viewOffset
                    }
            )
        }
    }
}

extension ButtonCell {
    class ViewModel: BaseViewModel {
        var text: String = ""
        var index: Int = 0
        @State private var isMoved = false
        
        func onAppear() {
        }
    }
}


#Preview {
    ButtonCell(viewModel: .init(container: .preview))
}
