//
//  DataManager.swift
//  X
//
//  Created by xhd2015 on 2019/11/3.
//  Copyright © 2019 snu2017. All rights reserved.
//

import Foundation

class DataManager {
    private init(){}
    
    
    /* db path
     */
    static var path:String {
        return NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
        ).first!
    }
    
    /*
     the writing manager
     */
    static var writingManager : WritingManager {
        return WritingManager(dbPath: "\(self.path)/data.sqlite3.db")
    }
    
    
    
}
