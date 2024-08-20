//
//  TextCell.swift
//  UISample
//
//  Created by 정영민 on 2024/08/13.
//

import SwiftUI

struct TextCell: View {
    let viewModel: ViewModel
    
    private let padding: CGFloat = 0
    
    var body: some View {
        content
            .onAppear {
                self.viewModel.onAppear()
            }
            .readSize { size in
                print("\(viewModel.text) \(size.width)")
            }
            .frame(width: viewModel.text == "_" ? 100 : nil, height: 40)
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.blue)
                    .offset(y: 0) // 텍스트 아래로 밑줄을 이동
                , alignment: .bottom
            )
    }
    
    var content: some View {
        Button {
            print(viewModel.text)
            viewModel.action?()
        } label: {
            Text(viewModel.text == "_" ? "" : viewModel.text)
                .font(.body1)
                .padding(EdgeInsets(top: 0, leading: padding, bottom: 0, trailing: padding))
        }
        .buttonStyle(.plain)
        .padding(4)
    }
}

extension TextCell {
    class ViewModel: BaseViewModel {
        var text: String = ""
        var index: Int = 0
        
        var action: Callback?
        
        var frameInGlobal: CGRect = .zero
        
        func onAppear() {
        }
    }
}


#Preview {
    TextCell(viewModel: .init(container: .preview))
}
