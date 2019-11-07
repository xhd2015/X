//
//  RemarkManager.swift
//  X
//
//  Created by xhd2015 on 2019/11/7.
//  Copyright © 2019 snu2017. All rights reserved.
//

import Foundation
import SQLite


class RemarkManager {
    
    typealias ErrorHandler = (_ e:Error) -> Void
    static let defaultHandler : ErrorHandler = { e in
        print("Error happened while operating database" + e.localizedDescription)
    }
    
    //let userTable:SQLite.Table = Table("users")
    
    let id = Expression<Int64>("id")
    let remark = Expression<String>("remark")
    let target = Expression<String>("target")
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
        try db.run(table().create(ifNotExists: true){t in
            t.column(id,primaryKey:true)
            t.column(remark)
            t.column(target)
            t.column(targetId)
            t.column(createTime)
            t.column(updateTime)
            }
        )
    }
    
    
    /*insert a user, after which the id is set
     */
    func insert(model:inout Remark) -> Bool{
        var x = model
        return runNoError {
            let rowId = try self.db.run(table().insert(
                remark <- x.remark,
                createTime <- x.createTime,
                updateTime <- x.updateTime,
                targetId <- x.targetId,
                target <- x.target
            ))
            model.id = rowId
        }
    }
    
    func update(model:Remark) -> Bool {
        var x = model
        return runNoError {
            if x.id <= 0 {
                throw SqliteException("sqlite model id not positive, id = \(x.id)")
            }
            let userTable = table()
            _ = userTable.filter(id == x.id)
            try self.db.run(userTable.update(
                remark <- x.remark,
                updateTime <- x.updateTime
                // targetId <- x.targetId,
                // target <- x.target
                
            ))
        }
    }
    
    func query(id:Int64) -> Remark?{
        var model:Remark? = nil
        _ = runNoError {
            let userTable = table()
            _ = userTable.filter(self.id == id)
            if let user = try self.db.pluck(userTable){
                model = Remark(
                    id: user[self.id],
                    remark: user[self.remark],
                    target: user[self.target],
                    targetId:  user[self.targetId],
                    createTime: user[self.createTime],
                    updateTime: user[self.updateTime])
                
            }
        }
        return model
    }
    
    /*
     * query from since to until, until is not included
     */
    func query(writingId:Int64) -> [Remark] {
        var arr = [Remark]()
        _ = runNoError {
            let userTable = table()
            //            userTable.filter(target == "writing" && targetId == writingId)
            for row in try self.db.prepare(userTable.where(target == "writing" && targetId == writingId)){
                arr.append(Remark(
                    id : row[self.id],
                    remark : row[self.remark],
                    target : row[self.target],
                    targetId : row[self.targetId],
                    createTime : row[self.createTime],
                    updateTime : row[self.updateTime]
                    
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
    
    func table() -> Table{
        return Table("remark")
    }
}
