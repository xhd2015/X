//
//  TagManager.swift
//  X
//
//  Created by xhd2015 on 2019/11/7.
//  Copyright © 2019 snu2017. All rights reserved.
//

import Foundation
import SQLite


class LinkMapManager {

    typealias ErrorHandler = (_ e: Error) -> Void
    static let defaultHandler: ErrorHandler = { e in
        print("Error happened while operating database" + e.localizedDescription)
    }

    //let userTable:SQLite.Table = Table("users")
//    let id = Expression<Int64>("id")
    let srcId = Expression<Int64>("src_id")
    let dstIds = Expression<String>("dst_ids")
//    let createTime = Expression<Date>("create_time")
//    let updateTime = Expression<Date>("update_time")

    var db: SQLite.Connection
    var errorHandler: ErrorHandler


    init(db: SQLite.Connection, errorHandler: @escaping ErrorHandler = SqliteModelManager.defaultHandler) throws {
        self.db = db
        self.errorHandler = errorHandler
        try ensureTableExists(db: db)
    }

    func ensureTableExists(db: SQLite.Connection) throws {
        try db.run(modelTable().create(ifNotExists: true) { t in
//            t.column(id,primaryKey:true)
            t.column(srcId, primaryKey: true)
            t.column(dstIds)
//            t.column(createTime)
//            t.column(updateTime)
        }
        )
    }


    /*insert a user, after which the id is set
     */
//    func insert(model:inout LinkMap) -> Bool{
//        var x = model
////        if x.createTime == nil {
////            x.createTime = Date()
////        }
////        if x.updateTime == nil {
////            x.updateTime = x.createTime
////        }
//        return runNoError {
//            let rowId = try self.db.run(modelTable().insert(
//                srcId <- x.srcId,
//                dstIds <- x.dstIds,
////                createTime <- x.createTime!,
////                updateTime <- x.updateTime!
//            ))
//            model.id = rowId
//        }
//    }
    /*
    * insert or replace
    */
    func updateFor(writingId: Int64, fullList: [Int64]) {
        runNoError {
            try db.run(self.modelTable().insert(or: .replace, self.srcId <- writingId, self.dstIds <- fullList.map({String($0)}).joined(separator: ",")))
        }
    }

    func remove(id: Int64) {
        runNoError {
            let userTable = modelTable()
            try self.db.run(userTable.filter(self.srcId == id).delete())
        }
    }

//    func query(id:Int64) -> TagMap?{
//        var model:TagMap? = nil
//        _ = runNoError {
//            let userTable = modelTable()
//            _ = userTable.filter(self.id == id)
//            if let row = try self.db.pluck(userTable){
//                model = TagMap(
//                    id:row[self.id],
//                    targetId: row[self.targetId],
//                    tagName: row[self.tagName],
//                    createTime: row[self.createTime],
//                    updateTime: row[self.updateTime]
//                )
//            }
//        }
//        return model
//    }

    /*
     * query from since to until, until is not included
     */
    func query(writingId: Int64) -> LinkMap? {
        var model: LinkMap? = nil
        _ = runNoError {
            let userTable = modelTable()
            //            userTable.filter(target == "writing" && targetId == writingId)
            if let row = try self.db.pluck(userTable.where(self.srcId == writingId)) {
                model = LinkMap(
//                    id:row[self.id],
                        srcId: row[self.srcId],
                        dstIds: row[self.dstIds]
//                    createTime: row[self.createTime],
//                    updateTime: row[self.updateTime]
                )
            }
        }
        return model
    }

    func runNoError(block: () throws -> Void) -> Bool {
        do {
            try block()
            return true
        } catch {
            errorHandler(error)
            return false
        }
    }

    func modelTable() -> Table {
        Table("link_map")
    }

}
