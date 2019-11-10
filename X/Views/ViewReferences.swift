//
//  ViewReferences.swift
//  X
//
//  Created by xhd2015 on 2019/11/8.
//  Copyright © 2019 snu2017. All rights reserved.
//

import Foundation


class ViewReferences {
    
    static var writingList : WritingList {
        return WritingList(since:DateUtils.toWeekMondayBegin())
    }

}
