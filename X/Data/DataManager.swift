//
//  DataManager.swift
//  X
//
//  Created by xhd2015 on 2019/11/3.
//  Copyright © 2019 snu2017. All rights reserved.
//

import Foundation
import SQLite

class DataManager {
    private init(){}
    
    
    /* db path
     */
    static var path:String {
        return NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
        ).first!
    }
    
    static var db:SQLite.Connection {
        do{
            let db =  try SQLite.Connection("\(path)/data.sqlite3.db")
            return db
        }catch{
            fatalError("Cannot open database:\(path)/data.sqlite3.db")
        }
    }
    
    /*
     the writing manager
     */
    static var writingManager : WritingManager {
        do{
            return try WritingManager(db: db)
        }catch{
            fatalError("Cannot create writing manager")
        }
    }
    static var remarkManager : RemarkManager {
        do{
            return try RemarkManager(db: db)
        }catch{
            fatalError("Cannot create remark manager")
        }
    }
    
    static var tagMapManager : TagMapManager {
        do{
            return try TagMapManager(db: db)
        }catch{
            fatalError("Cannot create tag map manager")
        }
    }
    
    
    
    
}
