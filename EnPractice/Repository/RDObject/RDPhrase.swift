//
//  RDPhrase.swift
//  PracticeEngDBBuilder
//
//  Created by 정영민 on 10/16/24.
//

import Foundation
import SQLite

struct RDPhrase: RDEntity {
    
    let phrase: String
    let id: UUID
    
    
    static var table: Table {
        return Table("DuPhrase")
    }
    
    static func map(row: Row) -> Self {
        let phrase = row[.phrase]
        let id = row[.id]
        
        return Self(
            phrase: phrase,
            id: id
        )
    }
    
    static func build(builder: TableBuilder) {
        builder.column(.phrase)
        builder.column(.id)
        builder.primaryKey(.phrase)
    }
    
    func insert() -> Insert {
        return Self.table.insert(
            .phrase <- phrase,
            .id <- id
        )
    }
    
    func update() -> Update {
        let object = Self.table.filter(.phrase == phrase)
        return object.update(
            .phrase <- phrase
        )
    }
    
    func delete() -> Delete {
        let object = Self.table.filter(.phrase == phrase)
        return object.delete()
    }
}
