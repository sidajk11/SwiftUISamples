//
//  HomeData.swift
//  EnPractice
//
//  Created by 정영민 on 1/12/25.
//

import Foundation

struct HomeData {
    struct Unit: Identifiable {
        let id: UUID
        let title: String
        let lessonList: [Lesson]
    }
    
    struct Lesson: Identifiable {
        let id: UUID
        let title: String
        let desc: String
    }
}
