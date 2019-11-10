//
//  WeekedSequence.swift
//  X
//
//  Created by xhd2015 on 2019/11/8.
//  Copyright © 2019 snu2017. All rights reserved.
//

import Foundation
import SwiftUI


class WeekedSequence : Sequence {
    var data:[Writing]
    var selected:NSMutableOrderedSet?
    init(_ data:[Writing],selected:NSMutableOrderedSet? = nil){
        self.data = data
        self.selected = selected
    }
    func makeIterator() -> WeekedIterable {
        return WeekedIterable(data:data,selected: self.selected)
    }
}
