//
//  TranslationPopup.swift
//  EnPractice
//
//  Created by 정영민 on 2024/08/19.
//

import SwiftUI

struct TranslationPopup: View {
    
    @Binding var text: String
    
    var body: some View {
        Text(text)
            .padding()
    }
}
