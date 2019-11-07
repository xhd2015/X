//
//  Remark.swift
//  X
//
//  Created by xhd2015 on 2019/11/7.
//  Copyright © 2019 snu2017. All rights reserved.
//

import Foundation

struct Remark : Identifiable {
    var id:Int64 = 0
    var remark:String = ""
    var target:String = ""
    var targetId:Int64 = 0
    var createTime:Date
    var updateTime:Date
}
