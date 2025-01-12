//
//  RDSentence.swift
//  PracticeEngDBBuilder
//
//  Created by 정영민 on 9/28/24.
//

import Foundation
import SQLite

struct RDSentence: RDEntity {
    
    let id: UUID
    let sentence: String
    let translation: String
    let level: Int
    let unit: Int
    
    static var table: Table {
        return Table("DuSentence")
    }
    
    static func map(row: Row) -> Self {
        let sentence = row[.sentence]
        let translation = row[.translation]
        let level = row[.level]
        let unit = row[.unit]
        let id = row[.id]
        
        return Self(
            id: id,
            sentence: sentence,
            translation: translation,
            level: level,
            unit: unit
        )
    }
    
    static func build(builder: TableBuilder) {
        builder.column(.sentence, primaryKey: true)
        builder.column(.translation)
        builder.column(.level)
        builder.column(.unit)
        builder.column(.id)
    }
    
    func insert() -> Insert {
        return Self.table.insert(
            .sentence <- sentence,
            .translation <- translation,
            .level <- level,
            .unit <- unit,
            .id <- id
        )
    }
    
    func update() -> Update {
        let object = Self.table.filter(.sentence == sentence)
        return object.update(
            .sentence <- sentence,
            .translation <- translation,
            .level <- level,
            .unit <- unit,
            .id <- id
        )
    }
    
    func delete() -> Delete {
        let object = Self.table.filter(.sentence == sentence)
        return object.delete()
    }
}
