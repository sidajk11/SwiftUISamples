//
//  Expression.swift
//  EnPractice
//
//  Created by 정영민 on 1/6/25.
//

import Foundation
import SQLite

extension SQLite.Expression<UUID> {
    static let id = SQLite.Expression<UUID>("id")
    static let wordId = SQLite.Expression<UUID>("wordId")
}

extension SQLite.Expression<String> {
    static let desc = SQLite.Expression<String>("desc")
    static let name = SQLite.Expression<String>("name")
    static let word = SQLite.Expression<String>("word")
    static let book = SQLite.Expression<String>("book")
    static let translation = SQLite.Expression<String>("translation")
    static let title = SQLite.Expression<String>("title")
    static let sentence = SQLite.Expression<String>("sentence")
    static let phrase = SQLite.Expression<String>("phrase")
    static let partOfSpeech = SQLite.Expression<String>("partOfSpeech")
    static let explain = SQLite.Expression<String>("explain")
    static let type = SQLite.Expression<String>("type")
}

extension SQLite.Expression<Int64> {
    
}

extension SQLite.Expression<Int> {
    static let chapter = SQLite.Expression<Int>("chapter")
    static let section = SQLite.Expression<Int>("section")
    static let wordOrder = SQLite.Expression<Int>("wordOrder")
    static let situationType = SQLite.Expression<Int>("situationType")
    static let level = SQLite.Expression<Int>("level")
    static let unit = SQLite.Expression<Int>("unit")
    static let orderIndex = SQLite.Expression<Int>("orderIndex")
    static let classNum = SQLite.Expression<Int>("classNum")
    static let hasPhrase = SQLite.Expression<Int>("hasPhrase")
    static let idx = SQLite.Expression<Int>("idx")
}
