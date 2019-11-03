//
//  DataUtils.swift
//  X
//
//  Created by xhd2015 on 2019/11/3.
//  Copyright © 2019 snu2017. All rights reserved.
//

import Foundation


class  DateUtils{
    private init(){}
    
    
    // format date
    
    //    January 2019
    //Su Mo Tu We Th Fr Sa
    //       1  2  3  4  5
    // 6  7  8  9 10 11 12
    //13 14 15 16 17 18 19
    //20 21 22 23 24 25 26
    //27 28 29 30 31
    
    static let YYYY_MM_DD:DateFormatter = getFormatter("yyyy-MM-dd")
    /*
     * HH = 24-Hour  hh = 12-Hour
     */
    static let YYYY_MM_DD_HH_MM_SS:DateFormatter = getFormatter("yyyy-MM-dd HH:mm:ss")
    
    
    static let GREGORIAN_CALENDAR = Calendar(identifier: .gregorian)
    
    static func getFormatter(_ format:String) ->DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "zh_CN")
        return formatter
    }
    
    static func getWeekdaySinceMonday(_ date:Date) -> Int{
        let day = GREGORIAN_CALENDAR.component(.weekday, from:date) // sunday = 1
        return day==1 ?6:(day-2)
    }
    
    static func getWeekOfYear(_ date:Date) -> Int {
        return GREGORIAN_CALENDAR.component(.weekOfYear, from:date)
    }
    
    static func getYear(_ date:Date) -> Int {
        return GREGORIAN_CALENDAR.component(.year,from: date)
    }
    static func getDayOfMonth(_ date:Date) -> Int {
        return GREGORIAN_CALENDAR.component(.day, from: date) - 1
    }
    static func getDayOfYear(_ date:Date) -> Int{
        return Int((toStartOfDay(date).timeIntervalSince1970 -  toYearBegin(date).timeIntervalSince1970)/(24.0*60.0*60.0))
    }
    
    static func parseDate(_ s:String,format:DateFormatter) -> Date?{
        if let date = format.date(from:s) {
            return date
        }else{
            return nil
        }
    }
    
    static func parseDate(_ s:String,format:String) ->Date? {
        return parseDate(s,format:getFormatter(format))
    }
    static func parseDate(_ s:String) -> Date?{
        return parseDate(s,format:YYYY_MM_DD);
    }
    static func parseDatetime(_ s:String) -> Date? {
        return parseDate(s, format:YYYY_MM_DD_HH_MM_SS)
    }
    static func toSeconds(_ date:Date) -> Int {
        return Int(date.timeIntervalSince1970)
    }
    
    static func toStartOfDay(_ date:Date)->Date{
        return GREGORIAN_CALENDAR.startOfDay(for:date)
    }
    static func toYearBegin(_ date:Date) -> Date {
        return GREGORIAN_CALENDAR.date(from:DateComponents(calendar: GREGORIAN_CALENDAR, year: getYear(date) ))!
    }
    /*
     * to week day begin, default current day
     */
    static func toWeekMondayBegin(_ date:Date? = nil) -> Date {
        let requiredData = date ??  Date()
        return Date(timeInterval: -(24.0*60.0*60.0)*(Double(getWeekdaySinceMonday(requiredData))), since:requiredData)
    }
    
    static func toDateString(_ date:Date) -> String {
        return YYYY_MM_DD.string(from:date)
    }
    
    static func toDateTimeString(_ date:Date) -> String {
        return YYYY_MM_DD_HH_MM_SS.string(from:date)
    }
    
    static func format(_ date:Date,format:DateFormatter)->String{
        return format.string(from:date)
    }
}
