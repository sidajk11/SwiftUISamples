//
//  Lesson.swift
//  UISample
//
//  Created by 정영민 on 7/20/24.
//

import Foundation

struct LessonModel: Codable, Identifiable {
    let levelNo: Int
    let unitNo: Int
    let id: UUID
    let lessonNo: Int
    let title: String
    let desc: String
}

extension LessonModel {
    init?(managedObject: LessonMO) {
        guard let lessonId = managedObject.lessonId,
              let title = managedObject.title,
              let desc = managedObject.desc
        else {
            return nil
        }
        let levelNo = managedObject.levelNo
        let unitNo = managedObject.unitNo
        let lessonNo = managedObject.lessonNo
        let uuid = UUID(uuidString: lessonId) ?? UUID()
        self.init(levelNo: Int(levelNo), unitNo: Int(unitNo), id: uuid, lessonNo: Int(lessonNo), title: title, desc: desc)
    }
}
