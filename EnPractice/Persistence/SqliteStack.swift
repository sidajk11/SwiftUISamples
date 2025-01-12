//
//  SqliteStack.swift
//  EnPractice
//
//  Created by 정영민 on 1/6/25.
//

import Foundation
import SQLite

protocol SqliteStore {
    func createTable(entityType: RDEntity.Type)
    func fetch<T: RDEntity>() -> [T]
    func fetch<T: RDEntity>(query: QueryType) -> T?
    func fetch<T: RDEntity>(query: QueryType) -> [T]
    func insert<T: RDEntity>(_ obj: T)
    func update<T: RDEntity>(_ obj: T)
    func delete<T: RDEntity>(_ obj: T)
    
    
    func addColumn<V: Value>(entityType: RDEntity.Type, _ expression: SQLite.Expression<V>, defaultValue: V)
    func version() -> Int32
    func setVersion(_ version: Int32)
}

struct SqliteStack: SqliteStore {
    
    private let db: Connection?
    
    init(path: String) {
        do {
            db = try Connection(path)
        } catch {
            db = nil
            print("Unable to open database")
        }
    }
    
    func addColumn<V: Value>(entityType: RDEntity.Type, _ expression: SQLite.Expression<V>, defaultValue: V) {
        do {
            try db?.run(entityType.table.addColumn(.id, defaultValue: UUID()))
        } catch {
            print("Unable to add column")
        }
    }
    
    func version() -> Int32 {
        return db?.userVersion ?? 0
    }
    
    func setVersion(_ version: Int32) {
        db?.userVersion = version
    }
    
    func createTable(entityType: RDEntity.Type) {
        do {
            try db?.run(entityType.table.create(ifNotExists: true) { tableBuilder in
                entityType.build(builder: tableBuilder)
            })
            
        } catch {
            print("Unable to create table")
        }
    }
    
    func fetch<T: RDEntity>(query: QueryType) -> T? {
        do {
            if let row = try db!.pluck(query) {
                return T.map(row: row)
            }
        } catch {
            print("Select failed")
        }
        return nil
    }
    
    func fetch<T: RDEntity>(query: QueryType) -> [T] {
        var list = [T]()
        do {
            for row in try db!.prepare(query) {
                list.append(T.map(row: row))
            }
        } catch {
            print("Select failed")
        }
        return list
    }
    
    func fetch<T: RDEntity>() -> [T] {
        var list: [T] = []
        do {
            for row in try db!.prepare(T.table) {
                list.append(T.map(row: row))
            }
        } catch {
            print("Select failed")
        }
        return list
    }
    
    func insert<T: RDEntity>(_ obj: T) {
        do {
            try db?.run(obj.insert())
        } catch let error {
            print("Insert failed: \(error)")
        }
    }
    
    func update<T: RDEntity>(_ obj: T) {
        do {
            try db?.run(obj.update())
        } catch {
            print("Update failed")
        }
    }
    
    func delete<T: RDEntity>(_ obj: T) {
        do {
            try db?.run(obj.delete())
        } catch {
            print("Delete failed")
        }
    }
}
