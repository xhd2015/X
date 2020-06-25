//
//  DateWeekInfo.swift
//  X
//
//  Created by xhd2015 on 2019/11/3.
//  Copyright © 2019 snu2017. All rights reserved.
//

import Foundation
import UIKit


class DateInfo {
    
    let date:Date
    
    
    /*
     * week of year, starting from 0
     */
    var weekOfYear: Int64 {
        get(){
          let calendar = NSCalendar.current
        let com = calendar.dateComponents([.year,.month,.day], from: self)
        }
    }
    
    /*
     * day of week, 0~6 , monday = 0
     */
    var dayOfWeek: Int64 {
        get(){
           // seconds since 1970
           let interval = Int(Date.timeIntervalSince1970)
           // days since 1970
           let days = Int(interval/(24*60*60)) // 24*60*60
           // 1970.01.01 = thursday(3)
           // 0=>3 1=>4 2=>5 3=>6 4=>0 5=>1 6=>2
           let remainging = days%7
           return remainging<=3? (remainging+3) : (remainging-4)
        }
    }
    
    
    init(date:Date){
        self.date = date
    }
    
}
