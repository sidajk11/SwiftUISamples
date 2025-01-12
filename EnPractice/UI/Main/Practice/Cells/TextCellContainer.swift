//
//  TextCell.swift
//  EnPractice
//
//  Created by 정영민 on 2024/08/06.
//

import SwiftUI

struct TextCellContainer: View {
    var textCell: ButtonCell
    
    @State private var size: CGSize?
    
    var body: some View {
        content
    }
    
    var content: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.appCyan700)
                .cornerRadius(12)
                .padding(1)
            textCell
                .layoutPriority(1)
        }
    }
}
