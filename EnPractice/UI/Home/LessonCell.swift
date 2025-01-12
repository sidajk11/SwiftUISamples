//
//  LessonCell.swift
//  EnPractice
//
//  Created by 정영민 on 2024/08/01.
//

import SwiftUI

struct LessonCell: View {
    
    let data: HomeData.Lesson
    
    var body: some View {
        content
    }
    
    var content: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(data.title)
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                Text(data.desc)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        //.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


#Preview {
    LessonCell(data: .init(id: UUID(), title: "", desc: ""))
}
