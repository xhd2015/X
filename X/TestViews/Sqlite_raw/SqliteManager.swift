//
//  SqliteManager.swift
//  X
//
//  Created by xhd2015 on 2019/11/3.
//  Copyright © 2019 snu2017. All rights reserved.
//

import Foundation

import SQLite


class SqliteManager {
    
    typealias ErrorHandler = (_ e:Error) -> Void
    static let defaultHandler : ErrorHandler = { e in
        print("Error happened while operating database" + e.localizedDescription)
    }
    
    var dbPath:String = ""
    
    lazy var db:SQLite.Connection = {
        do{
            return try SQLite.Connection(self.dbPath)
        }catch{
            fatalError("Cannot open database:" + dbPath)
        }
    }()
    
    /*:memory: or something else*/
    init(dbPath:String) {
        if dbPath.count == 0 {
            fatalError("Requires non empty db path")
        }
        self.dbPath = dbPath
    }
    
    func exec(_ sql:String,errorHandler:ErrorHandler = SqliteManager.defaultHandler){
        self.execMany(template: sql,args:[], errorHandler:errorHandler)
    }
    
    func exec(template:String, args:[Binding?] = [Binding?](),errorHandler:ErrorHandler = SqliteManager.defaultHandler){
        self.execMany(template:template, args:[args],errorHandler: errorHandler)
    }
    
    func execMany(template:String, args:[[Binding?]] = [[Binding?]](),errorHandler:ErrorHandler =  SqliteManager.defaultHandler){
        do {
            let statement:Statement = try self.db.prepare(template)
            for arg in args {
                try statement.run(arg)
            }
        } catch {
            errorHandler(error)
        }
    }
    
    func query(_ sql:String,errorHandler:ErrorHandler =  SqliteManager.defaultHandler) ->[Binding?]? {
        let res = self.queryMany(sql,errorHandler: errorHandler)
        if res.isEmpty {
            return nil
        }else{
            return res[0]
        }
        //        return res.isEmpty? (nil as [String:Binding?]?): res[0]
    }
    func queryMany(_ sql:String,errorHandler:ErrorHandler =  SqliteManager.defaultHandler) -> [[Binding?]] {
        var result = [[Binding?]]()
        do{
            let statement:Statement = try self.db.prepare(sql)
            for row in try statement{
                var thisObj = row
//                for e in row {
//                    if e is Number {
//                        thisObj["number"] = e
//                    }else if e is String {
//                        thisObj["string"] = e
//                    }else{
//                        fatalError("Other types are not handled yet")
//                    }
//                }
                result.append(thisObj)
            }
        }catch{
            errorHandler(error)
        }
        return result
    }
    
    //    func exec(_ sql:String,args:[Binding?]= [Binding?]()){
    //        let statement:Statement = self.db.prepare(sql)
    //        statement.run(args)
    //    }
    //
    
    
    
}
