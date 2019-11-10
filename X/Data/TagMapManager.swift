//
//  TagManager.swift
//  X
//
//  Created by xhd2015 on 2019/11/7.
//  Copyright © 2019 snu2017. All rights reserved.
//

import Foundation
import SQLite


class TagMapManager {
    
    typealias ErrorHandler = (_ e:Error) -> Void
    static let defaultHandler : ErrorHandler = { e in
        print("Error happened while operating database" + e.localizedDescription)
    }
    
    //let userTable:SQLite.Table = Table("users")

    let table = Table("tag_map")
    
    let id = Expression<Int64>("id")
    let name = Expression<String>("name")
    let tagName = Expression<String>("tag_name")
    let targetId = Expression<Int64>("target_id")
    let createTime = Expression<Date>("create_time")
    let updateTime = Expression<Date>("update_time")
    
    var db:SQLite.Connection
    var errorHandler:ErrorHandler
    
    
    init(db:SQLite.Connection, errorHandler:@escaping ErrorHandler = SqliteModelManager.defaultHandler) throws {
        self.db = db
        self.errorHandler = errorHandler
        try ensureTableExists(db: db)
    }
    
    func ensureTableExists(db:SQLite.Connection) throws {
        try db.run(tagMapTable().create(ifNotExists: true){t in
            t.column(id,primaryKey:true)
            t.column(tagName,check: tagName.length > 0)
            t.column(targetId)
            t.column(createTime)
            t.column(updateTime)
            }
        )
    }
    
    
    /*insert a user, after which the id is set
     */
    func insert(model:inout TagMap) -> Bool{
        var x = model
        if x.createTime == nil {
            x.createTime = Date()
        }
        if x.updateTime == nil {
            x.updateTime = x.createTime
        }
        return runNoError {
            let rowId = try self.db.run(tagMapTable().insert(
                tagName <- x.tagName,
                targetId <- x.targetId,
                createTime <- x.createTime!,
                updateTime <- x.updateTime!
            ))
            model.id = rowId
        }
    }
    
    func update(model:TagMap) -> Bool {
        var x = model
        return runNoError {
            if x.id <= 0 {
                throw SqliteException("sqlite model id not positive, id = \(x.id)")
            }
            if x.updateTime == nil {
                x.updateTime = Date()
            }
            let userTable = tagMapTable()
            _ = userTable.filter(id == x.id)
            try self.db.run(userTable.update(
                tagName <- x.tagName,
                updateTime <- x.updateTime!
                // targetId <- x.targetId,
                // target <- x.target
                
            ))
        }
    }
    
    func query(id:Int64) -> TagMap?{
        var model:TagMap? = nil
        _ = runNoError {
            let userTable = tagMapTable()
            _ = userTable.filter(self.id == id)
            if let row = try self.db.pluck(userTable){
                model = TagMap(
                    id:row[self.id],
                    targetId: row[self.targetId],
                    tagName: row[self.tagName],
                    createTime: row[self.createTime],
                    updateTime: row[self.updateTime]
                )
            }
        }
        return model
    }
    
    /*
     * query from since to until, until is not included
     */
    func query(writingId:Int64) -> [TagMap] {
        var arr = [TagMap]()
        _ = runNoError {
            let userTable = tagMapTable()
            //            userTable.filter(target == "writing" && targetId == writingId)
            for row in try self.db.prepare(userTable.where(targetId == writingId)){
                arr.append(TagMap(
                    id:row[self.id],
                    targetId: row[self.targetId],
                    tagName: row[self.tagName],
                    createTime: row[self.createTime],
                    updateTime: row[self.updateTime]
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
    
    func tagMapTable() -> Table{
        return Table("tag_map")
    }
    
    func tagTable() -> Table {
        return Table("tag")
    }
}
