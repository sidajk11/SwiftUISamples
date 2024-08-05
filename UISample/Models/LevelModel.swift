//
//  LevelModel.swift
//  UISample
//
//  Created by 정영민 on 2024/08/01.
//

import Foundation

struct LevelModel: Codable, Identifiable {
    let id: String
    let levelNo: Int
    let title: String
    let desc: String
}
