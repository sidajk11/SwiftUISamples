//
//  RDWord.swift
//  YMWebBrowser
//
//  Created by 정영민 on 9/16/24.
//

import Foundation
import SQLite

struct RDWord: RDEntity {
    
    let word: String
    let translation: String
    let orderIndex: Int
    let level: Int
    let unit: Int
    let hasPhrase: Int
    let type: String
    let id: UUID
    
    static var table: Table {
        return Table("DuWord")
    }
    
    static func map(row: Row) -> Self {
        let word = row[.word]
        let translation = row[.translation]
        let orderIndex = row[.orderIndex]
        let level = row[.level]
        let unit = row[.unit]
        let hasPhrase = row[.hasPhrase]
        let id = row[.id]
        let type = row[.type]
        
        return Self(
            word: word,
            translation: translation,
            orderIndex: orderIndex,
            level: level,
            unit: unit,
            hasPhrase: hasPhrase,
            type: type,
            id: id
        )
    }
    
    static func build(builder: TableBuilder) {
        builder.column(.word)
        builder.column(.translation)
        builder.column(.orderIndex)
        builder.column(.level)
        builder.column(.unit)
        builder.column(.hasPhrase)
        builder.column(.id)
        builder.column(.type)
        builder.primaryKey(.word, .translation)
    }
    
    func insert() -> Insert {
        return Self.table.insert(
            .word <- word,
            .translation <- translation,
            .orderIndex <- orderIndex,
            .level <- level,
            .unit <- unit,
            .hasPhrase <- hasPhrase,
            .type <- type,
            .id <- id
        )
    }
    
    func update() -> Update {
        let object = Self.table.filter(.word == word && .translation == translation)
        return object.update(
            .orderIndex <- orderIndex,
            .level <- level,
            .unit <- unit,
            .hasPhrase <- hasPhrase,
            .type <- type
        )
    }
    
    func delete() -> Delete {
        let object = Self.table.filter(.word == word && .translation == translation)
        return object.delete()
    }
}
