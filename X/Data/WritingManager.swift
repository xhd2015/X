//
//  DataManager.swift
//  X
//
//  Created by xhd2015 on 2019/11/3.
//  Copyright © 2019 snu2017. All rights reserved.
//

import Foundation
import SQLite


class WritingManager {
    
    typealias ErrorHandler = (_ e:Error) -> Void
    static let defaultHandler : ErrorHandler = { e in
        print("Error happened while operating database" + e.localizedDescription)
    }
    
    let table:SQLite.Table = Table("writings")
    let id = Expression<Int64>("id")
    let content = Expression<String>("content")
    let date = Expression<Date>("date")
    
    var db:SQLite.Connection
    var errorHandler:ErrorHandler
    
    
    init(db:SQLite.Connection, errorHandler:@escaping ErrorHandler = SqliteModelManager.defaultHandler) throws {
        self.db = db
        self.errorHandler = errorHandler
        try ensureTableExists(db: db)
    }
    
    func ensureTableExists(db:SQLite.Connection) throws {
        try db.run(table.create(ifNotExists: true){t in
            t.column(id,primaryKey:true)
            t.column(content)
            t.column(date)
            }
        )
    }
    
    
    /*insert a user, after which the id is set
     */
    func insert(writing:Writing) -> Bool{
        var x = writing
        return runNoError {
            let rowId = try self.db.run(table.insert(
                content <- writing.content,
                date <- writing.date
            ))
            x.id = rowId
        }
    }
    
    func update(writing:Writing) -> Bool {
        return runNoError {
            if writing.id <= 0 {
                throw SqliteException("sqlite model id not positive, id = \(writing.id)")
            }
            try self.db.run(self.table.filter(id == writing.id).update(
                content <- writing.content,
                date <- writing.date
            ))
        }
    }
    
    func query(id:Int64) -> Writing?{
        var writing:Writing? = nil
        _ = runNoError {
            if let model = try self.db.pluck(self.table.filter(self.id == id)){
                writing = Writing(id:model[self.id], content: model[self.content], date:model[self.date])
            }
        }
        return writing
    }
    
    /*
     * query from since to until, until is **included**
     */
    func query(since:Date? = nil,until:Date? = nil,tags:[String]? = nil,searchContent:String = "") -> [Writing] {
        var arr = [Writing]()
        _ = runNoError {
            // searchContent = like
            // tags  = join and in
            var condition = self.table
            var filterExpr:Expression<Bool> = Expression<Bool>(literal:"1=1")

            if since != nil {
                filterExpr = filterExpr && self.table[self.date] >= since!
            }
            if until != nil {
                filterExpr = filterExpr && self.table[self.date] <= until!
            }
            if !searchContent.isEmpty {
                filterExpr = filterExpr && self.table[self.content].like("%\(searchContent)%")
            }
            if let ntag = tags {
                if !ntag.isEmpty {
                    let tagTable = DataManager.tagMapManager.table
                    condition = condition.join(tagTable, on: tagTable[DataManager.tagMapManager.targetId] == self.table[self.id])
                    filterExpr = filterExpr && ntag.contains(tagTable[DataManager.tagMapManager.tagName])
                }
            }
            condition =  condition.filter(filterExpr)
                    .select(self.table[self.id],self.table[self.date],self.table[self.content])
            .order(self.table[self.date],self.table[self.id])

            for row in try self.db.prepare(condition){
                arr.append(Writing(
                    id: row[self.table[self.id]],
                    content: row[self.content],
                    date: row[self.date]
                ))
            }
        }
        return arr
    }

    func runNoError(block : () throws ->Void) -> Bool {
        do{
            try block()
            return true
        }catch{
            errorHandler(error)
            return false
        }
    }
    
    func getTable() -> Table{
        return Table("writings")
    }
}
