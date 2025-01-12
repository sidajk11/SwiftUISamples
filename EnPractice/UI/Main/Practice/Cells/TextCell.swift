//
//  TextCell.swift
//  EnPractice
//
//  Created by 정영민 on 2024/08/13.
//

import SwiftUI

struct TextCell: View {
    
    @State var data: CellData
    
    private let padding: CGFloat = 0
    
    var body: some View {
        content
            .readSize { size in
                print("\(data.text) \(size.width)")
            }
            .frame(width: data.text == "_" ? 100 : nil, height: 40)
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.blue)
                    .offset(y: 0) // 텍스트 아래로 밑줄을 이동
                , alignment: .bottom
            )
    }
    
    var content: some View {
        contentView()
    }
    
    @ViewBuilder
    private func contentView() -> some View {
        if data.type == .text {
            textView
        } else if data.type == .input {
            inputView
        } else {
            spaceView
        }
    }
    
    var textView: some View {
        Button {
            print(data.text)
            data.action?()
        } label: {
            Text(data.text)
                .font(.body1)
                .padding(EdgeInsets(top: 0, leading: padding, bottom: 0, trailing: padding))
        }
        .buttonStyle(.plain)
        .padding(4)
    }
    
    var inputView: some View {
        TextField("", text: $data.text)
            .buttonStyle(.plain)
            .padding(4)
            .frame(width: 100, height: 40)
    }
    
    var spaceView: some View {
        Rectangle()
    }
}

extension TextCell {
    class CellData: Identifiable {
        var type: CellType = .text
        var text: String = ""
        
        var index: Int = 0
        var action: Callback?
        var frameInGlobal: CGRect = .zero
    }
}

extension TextCell {
    enum CellType {
        case text
        case input
        case space
    }
}


#Preview {
    TextCell(data: .init())
}
