//
//  InputCell.swift
//  UISample
//
//  Created by 정영민 on 2024/08/22.
//

import SwiftUI

struct InputCell: View {
    @ObservedObject var viewModel: ViewModel
    
    private let padding: CGFloat = 0
    
    var body: some View {
        content
            .onAppear {
                self.viewModel.onAppear()
            }
            .readSize { size in
                print("\(viewModel.text) \(size.width)")
            }
            .frame(width: 100, height: 40)
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.blue)
                    .offset(y: 0) // 텍스트 아래로 밑줄을 이동
                , alignment: .bottom
            )
    }
    
    var content: some View {
        TextField("", text: $viewModel.text)
            .buttonStyle(.plain)
            .padding(4)
    }
}

extension InputCell {
    class ViewModel: BaseViewModel {
        @Published var text: String = ""
        var index: Int = 0
        
        var action: Callback?
        
        var frameInGlobal: CGRect = .zero
        
        func onAppear() {
        }
    }
}


#Preview {
    InputCell(viewModel: .init(container: .preview))
}
