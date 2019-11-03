//
//  SqliteModelManager.swift
//  X
//
//  Created by xhd2015 on 2019/11/3.
//  Copyright © 2019 snu2017. All rights reserved.
//

import Foundation
import SQLite


class SqliteModelManager {
    
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
            fatalError("Cannot open database:" + dbPath)
        }
    }()
    //let userTable:SQLite.Table = Table("users")
    let id = Expression<Int64>("id")
    let userName = Expression<String>("userName")
    let sex = Expression<String>("sex")
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
            t.column(userName)
            t.column(sex)
            t.column(date)
            
            }
        )
    }
    
    
    /*insert a user, after which the id is set
     */
    func insertUser(sqliteModel:SqliteModel) -> Bool{
        return runNoError {
            let rowId = try self.db.run(getTable().insert(
                userName <- sqliteModel.userName,
                sex <- sqliteModel.sex,
                date <- sqliteModel.date
            ))
            sqliteModel.id = rowId
        }
    }
    
    func updateUser(sqliteModel:SqliteModel) -> Bool {
        return runNoError {
            if sqliteModel.id <= 0 {
                throw SqliteException("sqlite model id not positive, id = \(sqliteModel.id)")
            }
            let userTable = getTable()
            _ = userTable.filter(id == sqliteModel.id)
            try self.db.run(userTable.update(
                userName <- sqliteModel.userName,
                sex <- sqliteModel.sex,
                date <- sqliteModel.date
            ))
        }
    }
    
    func queryUser(id:Int64) -> SqliteModel?{
        var sqliteModel:SqliteModel? = nil
        runNoError {
            let userTable = getTable()
            _ = userTable.filter(self.id == id)
            if let user = try self.db.pluck(userTable){
                sqliteModel = SqliteModel()
                sqliteModel!.id = user[self.id]
                sqliteModel!.sex = user[self.sex]
                sqliteModel!.date = user[self.date]
                sqliteModel!.userName = user[self.userName]
            }
        }
        return sqliteModel
    }
    
    
    func runNoError<T>(_ defVal:T , block : () throws ->T) -> T{
        do{
            return try block()
        }catch{
            errorHandler(error)
        }
        return defVal
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
        return Table("users")
    }
    
    
    
    
}
