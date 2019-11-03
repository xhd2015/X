//
//  DataManager.swift
//  X
//
//  Created by xhd2015 on 2019/11/3.
//  Copyright © 2019 snu2017. All rights reserved.
//

import Foundation


import Foundation
import SQLite


class WritingManager {
    
    typealias ErrorHandler = (_ e:Error) -> Void
    static let defaultHandler : ErrorHandler = { e in
        print("Error happened while operating database" + e.localizedDescription)
    }
    
    lazy var db:SQLite.Connection = {
        do{
            let db =  try SQLite.Connection(self.dbPath)
            try ensureTableExists(db: db)
            return db
        }catch{
            fatalError("Cannot open database:\(dbPath)")
        }
    }()
    //let userTable:SQLite.Table = Table("users")
    let id = Expression<Int64>("id")
    let content = Expression<String>("content")
    let date = Expression<Date>("date")
    
    var dbPath:String
    var errorHandler:ErrorHandler
    
    init(dbPath:String, errorHandler:@escaping ErrorHandler = SqliteModelManager.defaultHandler) {
        self.dbPath = dbPath
        self.errorHandler = errorHandler
    }
    
    func ensureTableExists(db:SQLite.Connection) throws {
        try db.run(getTable().create(ifNotExists: true){t in
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
            let rowId = try self.db.run(getTable().insert(
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
            let userTable = getTable()
            _ = userTable.filter(id == writing.id)
            try self.db.run(userTable.update(
                content <- writing.content,
                date <- writing.date
            ))
        }
    }
    
    func query(id:Int64) -> Writing?{
        var writing:Writing? = nil
        _ = runNoError {
            let userTable = getTable()
            _ = userTable.filter(self.id == id)
            if let user = try self.db.pluck(userTable){
                writing = Writing()
                writing!.id = user[self.id]
                writing!.content = user[self.content]
                writing!.date = user[self.date]
            }
        }
        return writing
    }
    
    func querySince(since:Date? = nil) -> [Writing] {
        var arr = [Writing]()
        _ = runNoError {
            let userTable = getTable()
            if since != nil {
               _ = userTable.filter(self.date >= since!)
            }
            for row in try self.db.prepare(userTable){
                arr.append(Writing(
                    id: row[self.id],
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
