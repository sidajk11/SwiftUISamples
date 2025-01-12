//
//  RDEntity.swift
//  PracticeEngDBBuilder
//
//  Created by 정영민 on 2024/08/29.
//

import Foundation
import SQLite

protocol RDEntity {
    static var table: Table { get }
    static func map(row: Row) -> Self
    static func build(builder: TableBuilder)
    
    func insert() -> Insert
    func update() -> Update
    func delete() -> Delete
}
