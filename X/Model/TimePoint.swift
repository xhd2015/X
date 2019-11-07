//
//  TimePoint.swift
//  X
//
//  Created by xhd2015 on 2019/11/6.
//  Copyright © 2019 snu2017. All rights reserved.
//

import Foundation



struct TimePair {
    
    var begin:String
    var end:String
    
    
    var beginPoint:TimePoint? {
        return TimePoint(text:begin)
    }
    var endPoint:TimePoint? {
        return TimePoint(text:end)
    }
}

struct TimePoint {
    var hour:Int
    var minute:Int
    
    init?(hour:Int,minute:Int) {
        self.hour = hour
        self.minute = minute
        if !check() {
            return nil
        }
    }
    
    init?(minutes:Int){
        self.hour = minutes/60
        self.minute = minutes%60
        if !check() {
            return nil
        }
    }
    
    init?(text:String){
        let a = text.split(separator: ":",maxSplits: 1)
        if a.count != 2 {
            // error
            return nil
        }
        if let s1 = Int(String(a[0])) {
            self.hour = s1
        }else{
            return nil
        }
        
        if let s2 = Int(String(a[1])) {
            self.minute = s2
        }else{
            return nil
        }
        if !check() {
            return nil
        }
    }
    
    init(date:Date){
        self.hour = DateUtils.GREGORIAN_CALENDAR.component(.hour, from: date)
        self.minute = DateUtils.GREGORIAN_CALENDAR.component(.minute, from: date)
    }
    
    func toMinutes() -> Int {
        return self.hour*60 + self.minute
    }
    
    
//    static func - (end:TimePoint,begin:TimePoint) -> TimePoint {
//        return TimePoint(minutes: end.toMinutes() - begin.toMinutes())
//    }
    
    func toString() -> String {
        return "\(hour):\(minute)"
    }
    
    func  check() -> Bool {
        return self.hour >= 0 && self.hour < 24 && self.minute >= 0 && self.minute < 60
    }
}
