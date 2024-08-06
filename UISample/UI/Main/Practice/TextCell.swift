//
//  TextCell.swift
//  UISample
//
//  Created by 정영민 on 2024/08/06.
//

import SwiftUI


struct TextCell: View {
    let viewModel: ViewModel
    
    var body: some View {
        //GeometryReader { proxy in
            content
                .onAppear {
                    self.viewModel.onAppear()
                }
        //}
    }
    
    var content: some View {
        Text(viewModel.text)
            .font(.body1)
        
    }
}

extension TextCell {
    class ViewModel: BaseViewModel, Hashable {
        var text: String = ""
        var size: CGSize = .init(width: 20, height: 20)
        var index: Int = 0
        
        func onAppear() {
        }
        
        static func == (lhs: ViewModel, rhs: ViewModel) -> Bool {
            return lhs.index == rhs.index
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(index)
        }
    }
}


#Preview {
    TextCell(viewModel: .init(container: .preview))
}
