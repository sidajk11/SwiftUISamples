//
//  InputCell.swift
//  EnPractice
//
//  Created by 정영민 on 2024/08/22.
//

import SwiftUI

struct InputCell: View {
    @State var data: CellData
    let action: (() -> Void)
    
    private let padding: CGFloat = 0
    
    var body: some View {
        content
            .readSize { size in
                print("\(data.text) \(size.width)")
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
        TextField("", text: $data.text)
            .buttonStyle(.plain)
            .padding(4)
    }
}

extension InputCell {
    class CellData {
        @Published var text: String = ""
        var index: Int = 0
        var frameInGlobal: CGRect = .zero
    }
}


#Preview {
    InputCell(data: .init(), action: {})
}
