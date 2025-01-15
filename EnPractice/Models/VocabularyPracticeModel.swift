//
//  VocabularyPracticeModel.swift
//  EnPractice
//
//  Created by 정영민 on 1/13/25.
//

import Foundation

struct VocabularyPracticeModel {
    let id: UUID
    let localWord: String
    let selectionList: [Selection]
    
    struct Selection {
        let imageName: String
        let enWord: String
    }
    
    static var preview: Self {
        let seletionBook = Selection(imageName: "📖", enWord: "Book")
        let seletionPhone = Selection(imageName: "📱", enWord: "Phone")
        let selections = [seletionBook, seletionPhone]
        return Self(id: UUID(), localWord: "핸드폰", selectionList: selections)
    }
}
