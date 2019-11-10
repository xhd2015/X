//
//  TagMap.swift
//  X
//
//  Created by xhd2015 on 2019/11/8.
//  Copyright © 2019 snu2017. All rights reserved.
//

import Foundation

struct LinkMap {
//    var id:Int64 = 0
    var srcId:Int64 = 0
    var dstIds:String = ""
//    var createTime:Date? = nil
//    var updateTime:Date? = nil

    var dstIdList:[Int64] {
        get {
            var list = [Int64]()
            for seq in self.dstIds.split(separator: ",") {
                if let i = Int64(String(seq)) {
                    list.append(i)
                }
            }
            return list
        }
        set {
            self.dstIds = newValue.map({ String($0) }).joined(separator: ",")
        }
    }
}
