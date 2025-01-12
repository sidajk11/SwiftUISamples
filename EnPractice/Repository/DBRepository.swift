//
//  dd.swift
//  EnPractice
//
//  Created by 정영민 on 1/6/25.
//

import Foundation
import SQLite

protocol DBRepository: NSObjectProtocol {
    func fetch() -> [RDWord]
    func fetch(level: Int) -> [RDWord]
    func fetch(level: Int, unit: Int) -> [RDWord]
    func fetchWords(fromLevel: Int, fromUnit: Int, toLevel: Int, toUnit: Int) -> [RDWord]
    func fetchWord(word: String) -> RDWord?
    
    func fetchPhraseWords() -> [RDWord]
    func fetchPhrases(startWith word: String) -> [RDPhrase]
    func savePhrases(phrases: [RDPhrase])
    func hasPhrase(word: String) -> Bool
    func isPhrase(phrase: String) -> Bool
    
    func insertWords(words: [RDWord])
    func updateWords(words: [RDWord])
    func saveWords(words: [RDWord])
    func deleteWord(word: RDWord)
    
    /// Sentences
    func fechSentences(level: Int, unit: Int) -> [RDSentence]
    func saveSentence(sentence: RDSentence)
    func deleteSentence(sentence: RDSentence)
}

class RealDBRepository: NSObject, DBRepository {
    let sqliteStore: SqliteStore
    
    init(sqliteStore: SqliteStore) {
        self.sqliteStore = sqliteStore
        self.sqliteStore.createTable(entityType: RDWord.self)
    }
    
    func fetch(word: String, translation: String) -> RDWord? {
        let query = RDWord.table.filter(.word.lowercaseString == word.lowercased() && .translation == translation)
        return sqliteStore.fetch(query: query)
    }
    
    func fetch() -> [RDWord] {
        let query = RDWord.table
            .order([Expression<Int>.orderIndex.asc])
        return sqliteStore.fetch(query: query)
    }
    
    func fetch(level: Int) -> [RDWord] {
        let query = RDWord.table
            .filter(.level == level)
            .order([Expression<Int>.orderIndex.asc])
        return sqliteStore.fetch(query: query)
    }
    
    func fetch(level: Int, unit: Int) -> [RDWord] {
        let query = RDWord.table
            .filter(.level == level && .unit == unit)
            .order([Expression<Int>.orderIndex.asc])
        return sqliteStore.fetch(query: query)
    }
    
    func fetchWords(fromLevel: Int, fromUnit: Int, toLevel: Int, toUnit: Int) -> [RDWord] {
        let query = {
            if fromLevel >= toLevel {
                return RDWord.table
                    .filter(.level == fromLevel && (.unit >= fromUnit && .unit <= toUnit)
                    )
                    .order([Expression<Int>.orderIndex.asc])
            } else {
                let levelRangeCondition = (.level > fromLevel && .level < toLevel)
                let fromLevelCondition = (.level == fromLevel && .unit >= fromUnit)
                let toLevelCondition = (.level == toLevel && .unit <= toUnit)
                return RDWord.table
                    .filter(levelRangeCondition || fromLevelCondition || toLevelCondition)
                    .order([Expression<Int>.orderIndex.asc])
            }
        }()
        return sqliteStore.fetch(query: query)
    }
    
    func fetchWord(word: String) -> RDWord? {
        let query = RDWord.table
            .filter(.word.lowercaseString == word.lowercased())
        return sqliteStore.fetch(query: query)
    }
    
    func fetchPhraseWords() -> [RDWord] {
        let query = RDWord.table
            .filter(Expression<String>.word.like("% %"))
        return sqliteStore.fetch(query: query)
    }
    
    func fetchPhrases(startWith word: String) -> [RDPhrase] {
        let query = RDPhrase.table
            .filter(Expression<String>.phrase.lowercaseString.like("\(word.lowercased()) %"))
        return sqliteStore.fetch(query: query)
    }
    
    func savePhrases(phrases: [RDPhrase]) {
        phrases.forEach { phrase in
            sqliteStore.insert(phrase)
        }
    }
    
    func hasPhrase(word: String) -> Bool {
        return false
    }
    
    func isPhrase(phrase: String) -> Bool {
        return false
    }
    
    func insertWords(words: [RDWord]) {
        words.forEach { word in
            sqliteStore.insert(word)
        }
    }
    
    func updateWords(words: [RDWord]) {
        words.forEach { word in
            sqliteStore.update(word)
        }
    }
    
    func saveWords(words: [RDWord]) {
        words.forEach { word in
            if let _ = fetchWord(word: word.word) {
                sqliteStore.update(word)
            } else {
                sqliteStore.insert(word)
            }
        }
    }
    
    func deleteWord(word: RDWord) {
        sqliteStore.delete(word)
    }
}

extension RealDBRepository {
    /// Sentences
    func fechSentences(level: Int, unit: Int) -> [RDSentence] {
        let query = RDSentence.table
            .filter(.level == level && .unit == unit)
        return sqliteStore.fetch(query: query)
    }
    
    func saveSentence(sentence: RDSentence) {
        if let _ = fetchSentence(content: sentence.sentence) {
            sqliteStore.update(sentence)
        } else {
            sqliteStore.insert(sentence)
        }
    }
    
    func deleteSentence(sentence: RDSentence) {
        sqliteStore.delete(sentence)
    }
    
    private func fetchSentence(content: String) -> RDSentence? {
        let query = RDSentence.table
            .filter(.sentence == content)
        return sqliteStore.fetch(query: query)
    }
}
