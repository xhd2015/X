//
//  WritingList.swift
//  X
//
//  Created by xhd2015 on 2019/11/3.
//  Copyright © 2019 snu2017. All rights reserved.
//

import SwiftUI
import Foundation

struct WritingList: View {
    
    static let YYYY_MM_DD = DateUtils.getFormatter("yyyy年MM月dd日")
    
    class WeekstartAndItem : Identifiable{
        var year:Int = 0
        var week:Int = 0
        var writing:Writing
        init( writing:Writing){
            self.writing = writing
        }
        
        var id:Date {
            return writing.date
        }
    }
    //    class GroupedItem {
    //        var weekStart:Date;
    //        var list:[Writing] = []
    //        init(weekStart:Date, list:[Writing]){
    //            self.weekStart = weekStart
    //            self.list = list
    //        }
    //    }
    
    //
    class WeekedIterable : IteratorProtocol {
        
        typealias Element = WeekstartAndItem
        
        var data:[Writing]
        var lastYear = -1
        var lastWeekOfYear = -1
        var idx = 0
        
        init(data:[Writing]){
            self.data = data
        }
        
        
        func next()  -> WeekstartAndItem? {
            if idx == data.count {
                return nil
            }
            let item = data[idx]
            idx = idx + 1
            let thisYear = DateUtils.getYear(item.date)
            let thisWeekOfYear = DateUtils.getWeekOfYear(item.date)
            
            let result = WeekstartAndItem(writing: item)
            // a older one
            if lastYear != -1 && lastWeekOfYear != -1 && lastYear == thisYear && lastWeekOfYear == thisWeekOfYear {
                return  result
            }
            
            lastYear = thisYear
            lastWeekOfYear = thisWeekOfYear
            result.year = thisYear
            result.week = thisWeekOfYear
            return result
        }
    }
    
    class WeekedSequence : Sequence {
        var data:[Writing]
        init(_ data:[Writing]){
            self.data = data
        }
        func makeIterator() -> WeekedIterable {
            return WeekedIterable(data:data)
        }
    }
    
    /*
     * tuple are copied by value, not by reference
     */
    //    typealias GroupedItem = (weekStart:Date,list:[Writing])
    //    typealias GroupedData = [GroupedItem]
    /*
     * assert the data are sorted by date already
     */
    @State var data:[Writing]
    
    
    /*
     * linked hash map,
     */
    //    var groupedData:GroupedData{
    //        var grp = GroupedData()
    //        var curYear = -1
    //        var curWeekOfYear = -1
    //        var item:GroupedItem? = nil
    //        for datum in data {
    //            let date = datum.date
    //            let thisYear = DateUtils.getYear(date)
    //            let thisWeekOfYear = DateUtils.getWeekOfYear(date)
    //            if item == nil || curYear == -1 || curWeekOfYear == -1 || curYear != thisYear || curWeekOfYear != thisWeekOfYear {
    //                item = GroupedItem(weekStart: DateUtils.toWeekMondayBegin(date),list:[Writing]())
    //                grp.append(item!)
    //            }
    //            curYear = thisYear
    //            curWeekOfYear = thisWeekOfYear
    //            item!.list.append(datum)
    //            print("grp = \(grp.description)")
    //        }
    //        return grp
    //    }
    
    var body: some View {
        List{
            ForEach( Array(WeekedSequence(data))){ groupItem in
                
                VStack {
                    if groupItem.week != 0 {
                        Text("\(DateUtils.format(groupItem.writing.date, format: WritingList.YYYY_MM_DD)) 第\(groupItem.week+1)周 第\(DateUtils.getDayOfYear(groupItem.writing.date)+1)天")
                            .background(Color.blue)
                    }else{
                        Text("\(DateUtils.format(groupItem.writing.date, format: WritingList.YYYY_MM_DD))")
                    }
                    Text(groupItem.writing.content)
                }.frame( alignment: Alignment.leading)
                //
                //                VStack{ Text("\(DateUtils.format(groupItem.weekStart, format: WritingList.YYYY_MM_DD)), size = \(groupItem.list.count)")
                //                    .background(Color.blue)
                //
                //                    List{
                //                        Text("hah")
                //                        Text("haha2")
                ////                        ForEach(groupItem.list){ _ in
                ////                            Text("haha")
                ////                        }
                //                    }
                //                }
                //                Text(DateUtils.toDateTimeString(groupItem.weekStart))
                //                ForEach(groupItem.list, id: \.date){_ in
                //                    Text("OK")
                //                }
                
            }
        }
        
    }
}

struct WritingList_Previews: PreviewProvider {
    static var previews: some View {
        WritingList(data:[
            Writing(id:1, content:"I craeted a new content",date:DateUtils.parseDatetime("2019-10-01 09:10:00")!),
            
            Writing(id:2, content:"I Updated some content",date:DateUtils.parseDatetime("2019-10-02 09:13:00")!)
        ])
    }
}
