//
//  TextCell.swift
//  UISample
//
//  Created by 정영민 on 2024/08/06.
//

import SwiftUI

struct TextCellContainer: View {
    var textCell: ButtonCell?
    
    var body: some View {
        content
            .background(.appBlue300)
    }
    
    var content: some View {
        textCell
    }
}
