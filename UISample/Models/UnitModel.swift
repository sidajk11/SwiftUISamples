//
//  UnitModel.swift
//  UISample
//
//  Created by 정영민 on 2024/08/01.
//

import Foundation

struct UnitModel: Codable, Identifiable {
    let id: UUID
    
    let levelNo: Int
    let unitNo: Int
    let title: String
    let desc: String
    let imageUrl: String
}

extension UnitModel {
    init?(managedObject: UnitMO) {
        guard let unitId = managedObject.unitId,
              let title = managedObject.title,
              let desc = managedObject.desc
        else {
            return nil
        }
        let levelNo = managedObject.levelNo
        let unitNo = managedObject.unitNo
        let uuid = UUID(uuidString: unitId) ?? UUID()
        self.init(id: uuid, levelNo: Int(levelNo), unitNo: Int(unitNo), title: title, desc: desc, imageUrl: "")
    }
}
