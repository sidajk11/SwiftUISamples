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
    
    var isUpdated = PassthroughSubject<Void, Never>()
    
    @State var isMoved: Bool = false
    @State private var lastDragPosition = CGPoint.zero
    
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
                isUpdated.send()
            } label: {
                Text(viewModel.text)
                    .font(.subtitle1)
                    .padding(EdgeInsets(top: 0, leading: padding, bottom: 0, trailing: padding))
            }
            .buttonStyle(.plain)
            .clipShape(.rect(cornerRadii: .init(topLeading: 2, bottomLeading: 2, bottomTrailing: 2, topTrailing: 2)))
            .padding(4)
            .offset(x: viewModel.viewOffset.x, y: viewModel.viewOffset.y)
            .simultaneousGesture(
                DragGesture()
                    .onChanged { value in
                        viewModel.viewOffset = CGPoint(x: lastDragPosition.x + value.translation.width,
                                            y: lastDragPosition.y + value.translation.height)
                    }
                    .onEnded { value in
                        lastDragPosition = viewModel.viewOffset
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
        @Published var viewOffset = CGPoint.zero
        
        func onAppear() {
        }
    }
}


#Preview {
    ButtonCell(viewModel: .init(container: .preview))
}
