//
//  AnswerTextCell.swift
//  UISample
//
//  Created by 정영민 on 2024/08/12.
//

import SwiftUI

struct AnswerTextCell: View {
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
    }
    
    var content: some View {
        Button {
            print(viewModel.text)
        } label: {
            Text(viewModel.text)
                .font(.subtitle1)
                .padding(EdgeInsets(top: 0, leading: padding, bottom: 0, trailing: padding))
        }
        .buttonStyle(.plain)
        .clipShape(.rect(cornerRadii: .init(topLeading: 2, bottomLeading: 2, bottomTrailing: 2, topTrailing: 2)))
    }
}

extension AnswerTextCell {
    class ViewModel: BaseViewModel {
        var text: String = ""
        var index: Int = 0
        
        func onAppear() {
        }
    }
}


#Preview {
    AnswerTextCell(viewModel: .init(container: .preview))
}
