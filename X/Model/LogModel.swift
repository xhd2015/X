//
//  LogModel.swift
//  X
//
//  Created by mac on 2019/10/25.
//  Copyright © 2019 snu2017. All rights reserved.
//

class LogModel : Identifiable {
    var type : String
    
    init(_ type : String) {
        self.type = type
    }}

class DateSeparator : LogModel {
    var date : String
    override init(_ date :String) {
        self.date = date
        super.init("date")
    }
}

class ShortLogModel : LogModel {
    var content : String
    override init(_ content: String) {
        self.content = content
        super.init("shortLog")
    }
}

class BlogModel: LogModel {
    var title : String
    var content : String
    init(title:String, content:String) {
        self.title = title
        self.content = content
        super.init("blogModel")
    }
}
