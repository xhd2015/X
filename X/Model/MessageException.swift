//
// Created by xhd2015 on 2019/11/9.
// Copyright (c) 2019 snu2017. All rights reserved.
//

import Foundation

struct MessageException:Error{
    var cause:Error?
    var localizedDescription:String



     init(_ msg:String,cause:Error? = nil){
         self.cause = cause
         self.localizedDescription = msg
     }
}
