//
//  TextCell.swift
//  UISample
//
//  Created by 정영민 on 2024/08/06.
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
    }
    
    var content: some View {
        Button {
            
        } label: {
            Text(viewModel.text)
                .font(.body1)
                .padding(EdgeInsets(top: 0, leading: padding, bottom: 0, trailing: padding))
        }
        .buttonStyle(.plain)
    }
}

extension TextCell {
    class ViewModel: BaseViewModel {
        var text: String = ""
        var index: Int = 0
        
        func onAppear() {
        }
    }
}


#Preview {
    TextCell(viewModel: .init(container: .preview))
}
