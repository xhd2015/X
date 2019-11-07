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
    static let HH_MM_SS = DateUtils.getFormatter("HH:mm:ss")
    static let HH_MM = DateUtils.getFormatter("HH:mm")
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
    
    /*
     * week of year, start from 0, the last days of the year is considered week of the year
     */
    static func getWeekOfYear(_ date:Date) -> Int {
        var weekOfYear = GREGORIAN_CALENDAR.component(.weekOfYear, from:date) - 1
        
        if weekOfYear == 0 {
            // last week of month 12 is not considered one week of its belonging year
            // we need to fix this
            if getMonth(date) == 11 {
                let weekDay = getWeekdaySinceMonday(date)
                if weekDay == 6 {
                    weekOfYear = GREGORIAN_CALENDAR.component(.weekOfYear, from: GREGORIAN_CALENDAR.date(byAdding: .day, value: -1, to: date)!)
                }else{
                    // reget with the last validated week adding by 1
                    weekOfYear = GREGORIAN_CALENDAR.component(.weekOfYear, from: GREGORIAN_CALENDAR.date(byAdding: .day, value: -weekDay-2, to: date)!)
                }
            }
        }
        return weekOfYear
    }
    /*
     * week count of a year
     * definition of last week: the week of the last day
     * calculation: do not use internal definition of week of year, that does not count week span years, and they treat sunday that week
     */
    static func getWeekCountOfYear(_ year:Int)->Int?{
        if let yearLastDay = GREGORIAN_CALENDAR.date(from:DateComponents(calendar: GREGORIAN_CALENDAR, year: year, month: 12,day:31)) {
            return getWeekOfYear(yearLastDay) + 1
        }
        return nil
    }
    
    /*
     * week count of a year, invalid if year is not representable
     */
    static func getWeekCountOfYear(_ date:Date)->Int{
        return getWeekCountOfYear(getYear(date))!
    }
    
    static func getYear(_ date:Date) -> Int {
        return GREGORIAN_CALENDAR.component(.year,from: date)
    }
    /*
     * month: start from 0
     */
    static func getMonth(_ date:Date) -> Int{
        return GREGORIAN_CALENDAR.component(.month, from: date) - 1
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
    
    static func toDateBegin(_ date:Date? = nil) -> Date {
        let requiredData = date ??  Date()
        return GREGORIAN_CALENDAR.date(bySettingHour: 0, minute: 0, second: 0, of: requiredData)!
    }
    /*
     * to week day begin, default current day
     */
    static func toWeekMondayBegin(_ date:Date? = nil) -> Date {
        let requiredData = date ??  Date()
        let diffDay = getWeekdaySinceMonday(requiredData)
        return toDateBegin(GREGORIAN_CALENDAR.date(byAdding: .day, value: -diffDay, to: requiredData)!)
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
    
    static func toNextNoon(_ date:Date) -> Date {
        let hour = DateUtils.GREGORIAN_CALENDAR.component(.hour, from: date)
        if hour >= 0 && hour < 12 {
            return  DateUtils.GREGORIAN_CALENDAR.date(bySettingHour: 12, minute: 0, second: 0, of: date)!
        }else{
            return DateUtils.GREGORIAN_CALENDAR.date(byAdding: .day, value: 1, to: DateUtils.GREGORIAN_CALENDAR.date(bySettingHour: 12, minute: 0, second: 0, of: date)!)!
        }
    }
    
}

