//
//  A.swift
//  X
//
//  Created by xhd2015 on 2019/11/8.
//  Copyright © 2019 snu2017. All rights reserved.
//

import Foundation


enum NoteContextualType {
    case WEEK_BEGINNING,DAY_BEGINNING,ORDINARY;
}

/**
 * a single note providing more contextual information
 * i.e.  if it is beginning of a week,
 *       if it starts a new day
 */
struct WeekstartAndItem : Identifiable{
    
    
    var year:Int = 0
    var week:Int = 0
    var dayOfWeek:Int = 0
    var contextualType:NoteContextualType = .ORDINARY
    
    var writing:Writing
    
    var selected:Bool = false
    
    var id:Int64 {
        return writing.id
    }
    
    init(writing: Writing) {
        self.writing = writing
    }
}
