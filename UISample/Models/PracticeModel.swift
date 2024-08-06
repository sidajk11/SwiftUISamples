//
//  PracticeModel.swift
//  UISample
//
//  Created by 정영민 on 2024/08/06.
//

import Foundation

struct PracticeModel: Codable {
    let levelNo: Int
    let unitNo: Int
    let id: UUID
    let lessonNo: Int
    let title: String
    let desc: String
}

extension PracticeModel {
    init?(managedObject: PracticeMO) {
        guard let practiceId = managedObject.practiceId,
              let title = managedObject.title,
              let desc = managedObject.desc
        else {
            return nil
        }
        let levelNo = managedObject.levelNo
        let unitNo = managedObject.unitNo
        let lessonNo = managedObject.lessonNo
        let uuid = UUID(uuidString: practiceId) ?? UUID()
        self.init(levelNo: Int(levelNo), unitNo: Int(unitNo), id: uuid, lessonNo: Int(lessonNo), title: title, desc: desc)
    }
}
