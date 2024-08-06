//
//  UnitModel.swift
//  UISample
//
//  Created by 정영민 on 2024/08/01.
//

import Foundation

struct UnitModel: Codable, Identifiable {
    let id: String
    
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
        self.init(id: unitId, levelNo: Int(levelNo), unitNo: Int(unitNo), title: title, desc: desc, imageUrl: "")
    }
}
