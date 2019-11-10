//
//  WeekedIterable.swift
//  X
//
//  Created by xhd2015 on 2019/11/8.
//  Copyright © 2019 snu2017. All rights reserved.
//

import Foundation

class WeekedIterable : IteratorProtocol {
       
       typealias Element = WeekstartAndItem
       
       var data:[Writing]
       var selected:NSMutableOrderedSet?
       var lastYear = -1
       var lastWeekOfYear = -1
       var lastDayOfWeek = -1
       var idx = 0
       
       init(data:[Writing],selected:NSMutableOrderedSet? = nil){
           self.data = data
           self.selected = selected
       }
       
       
       func next()  -> WeekstartAndItem? {
           if idx == data.count {
               return nil
           }
           let item = data[idx]
           idx = idx + 1
           let thisYear = DateUtils.getYear(item.date)
           let thisWeekOfYear = DateUtils.getWeekOfYear(item.date)
           let thisDayOfWeek = DateUtils.getWeekdaySinceMonday(item.date)

           var sel = false
           if let s = self.selected {
               sel = s.contains(item.id)
           }
           var result = WeekstartAndItem(writing: item)
           result.selected = sel
           // same week
           if lastYear != -1 && lastWeekOfYear != -1 && lastYear == thisYear && lastWeekOfYear == thisWeekOfYear {
               // same day
               if lastDayOfWeek != -1 && lastDayOfWeek == thisDayOfWeek {
                   // remain default
                   return result
               }
               result.contextualType = .DAY_BEGINNING
               result.dayOfWeek = thisDayOfWeek
               lastDayOfWeek = thisDayOfWeek
               return  result
           }
           
           result.contextualType = .WEEK_BEGINNING
           lastYear = thisYear
           lastWeekOfYear = thisWeekOfYear
           lastDayOfWeek = thisDayOfWeek
           result.year = thisYear
           result.week = thisWeekOfYear
           result.dayOfWeek = thisDayOfWeek
           return result
       }
   }
