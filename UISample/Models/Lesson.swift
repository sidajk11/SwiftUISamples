//
//  Lesson.swift
//  UISample
//
//  Created by 정영민 on 7/20/24.
//

import Foundation

struct Lesson: Codable {
    let lessonId: String
    let lessonNo: Int32
    let name: String
}

extension Lesson {
    init?(managedObject: LessonMO) {
        guard let lessonId = managedObject.lessonId,
              let name = managedObject.name else {
            return nil
        }
        let lessonNo = managedObject.lessonNo
        self.init(lessonId: lessonId, lessonNo: lessonNo, name: name)
    }
}
