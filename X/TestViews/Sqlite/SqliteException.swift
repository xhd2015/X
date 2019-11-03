//
//  SqliteException.swift
//  X
//
//  Created by xhd2015 on 2019/11/3.
//  Copyright © 2019 snu2017. All rights reserved.
//

import Foundation

class SqliteException : Error {
    
    var localizedDescription:String
    
    init(_ message:String){
        self.localizedDescription = message
    }
    
    var message:String {
        return self.localizedDescription
    }
    
}
