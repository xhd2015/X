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
    static let HH_MM_SS = DateUtils.getFormatter("HH:mm:ss")
    static let WEEK_NAMES = ["周一","周二","周三","周四","周五","周六","周日"]
    
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
        var  contextualType:NoteContextualType = .ORDINARY
        
        var writing:Writing
        
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
        var lastDayOfWeek = -1
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
            let thisDayOfWeek = DateUtils.getWeekdaySinceMonday(item.date)
            
            var result = WeekstartAndItem(writing: item)
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
    
    @State var since:Date? = nil
    @State var until:Date? = nil
    /*
     * assert the data are sorted by date already
     */
    //    @State
    @State var data:[Writing]? = nil
    
    var viewData:[Writing] {
        //        print("reprinting")
        //        return [Writing]()
        if data == nil {
            return self.queryData()
        }
        return data!
    }
    
    
    // TODO buggy: with init, self.data cannot be assigned correctly,the underlying problem is not determined
    // we fix the lazy initiating problem by settting computed property
    //    init(since:Date? = nil, until:Date? = nil, data:[Writing]?){
    //        self.data = data!
    //        self.since = since
    //        self.until = until
    //        self.data = data
    //        if self.data == nil {
    //            self.refreshData()
    //        }
    //    }
    
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
        VStack {
            HStack {
                Spacer()
                
                Button(action:{
                    self.refreshData()
                }){
                    Text("Refresh")
                }
                NavigationLink(destination: WriterView()){
                    Text("Write")
                }
                
                
                NavigationLink(destination: MiscListView()){
                    Text("More")
                }
                
            }.padding(Edge.Set.trailing, 20.0)
            List{
                ForEach(Array(WeekedSequence(viewData))){ groupItem in
                    // show title, content, and time
                    VStack(alignment:.leading) {
                        HStack{
                            if groupItem.contextualType == WritingList.NoteContextualType.WEEK_BEGINNING  {
                                Text(WritingList.formatLeadingDate(groupItem.writing.date,week: groupItem.week))
                                    .background(Color.blue)
                            }else if groupItem.contextualType == WritingList.NoteContextualType.DAY_BEGINNING {
                                Text(WritingList.formatOrdinaryDate(groupItem.writing.date,week:groupItem.week))
                                //                                    .background(Color(white: 100))
                            }
                            //                            }
                            //else{
                            //                                Text("OJBK")
                            //                            }
                            Spacer()
                        }
                        
                        NavigationLink(destination: WritingDetailView(writing:groupItem.writing)){
                            Text(groupItem.writing.content)
                                .fontWeight(.semibold)
                        }
                        
                        Text(WritingList.formatTime(groupItem.writing.date))
                            .font(.system(size: 15))
                            .italic()
                            .fontWeight(.ultraLight)
                            .foregroundColor(.gray)
                        
                        
                        
                    }.frame( alignment: Alignment.leading)
                    
                }
                .padding(.trailing,1)
            }
            //            .padding(.trailing,1)
        }
    }
    
    // this get called
    //    func onAppear(perform action: (() -> Void)? = nil) -> some View
    //    {
    //        print("sub appeared")
    //        action?()
    //        return self
    //    }
    
    func refreshData(){
        self.data = self.queryData()
    }
    /*
     * to avoid modifying data refreshing views
     */
    func queryData() -> [Writing]{
        return DataManager.writingManager.query(since: self.since, until: self.until)
    }
    
    static func formatLeadingDate(_ date:Date,week:Int) -> String {
        return "\(DateUtils.format(date, format: WritingList.YYYY_MM_DD))·\(WritingList.WEEK_NAMES[DateUtils.getWeekdaySinceMonday(date)]) 第\(week+1)/\(DateUtils.getWeekCountOfYear(date))周 第\(DateUtils.getDayOfYear(date)+1)天"
    }
    static func formatOrdinaryDate(_ date:Date,week:Int) -> String {
        return "\(DateUtils.format(date, format: WritingList.YYYY_MM_DD))·\(WritingList.WEEK_NAMES[DateUtils.getWeekdaySinceMonday(date)])"
    }
    static func formatTime(_ date:Date) -> String {
        return DateUtils.format(date, format: DateUtils.HH_MM_SS)
    }
    
    // this will not be called
    //    func onAppear(perform: (()->Void)? = nil ) {
    //        //        super.onAppear(perform:perform)
    //        print("sub appeared")
    //        perform?()
    //    }
    
}

struct WritingList_Previews: PreviewProvider {
    static var previews: some View {
        WritingList(data:[
            Writing(id:1, content:"I created a new content",date:DateUtils.parseDatetime("2019-10-01 09:10:00")!),
            
            Writing(id:2, content:"I Updated some content",date:DateUtils.parseDatetime("2019-10-02 09:13:00")!),
            Writing(id:3, content:"I Updated some content also",date:DateUtils.parseDatetime("2019-10-02 09:15:00")!),
            
            Writing(id:4, content:"I Updated some content also Loooooooooooooooooooooooooooooooooooooong Cooooooooooooooooooooontent",date:DateUtils.parseDatetime("2019-10-02 09:15:00")!)
        ])
    }
}
