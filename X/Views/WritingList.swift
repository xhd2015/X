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
    static let WEEK_NAMES = ["周一", "周二", "周三", "周四", "周五", "周六", "周日"]

    // view state
    //    normal state -> item clickable -> clicked -> detail view
    //    edit state -> item selectable -> selected/cancel
    //    onAppear && set edit state
    //    onDisappear && set non-edit state

    /*
     * tuple are copied by value, not by reference
     */
    //    typealias GroupedItem = (weekStart:Date,list:[Writing])
    //    typealias GroupedData = [GroupedItem]
    @State var showEditSwitch: Bool = false
    // view,edit
    @State var mode: String
//    @State var mode: String = "edit"

    @State var since: Date?
    @State var until: Date?
    /*
     * assert the data are sorted by date already
     */
    //    @State
    @State var data: [Writing] {
        didSet {
            self.weekSeqArray = Array(WeekedSequence(data,selected: self.selected?.wrappedValue))
        }
    }
    @State var weekSeqArray: [WeekstartAndItem]
    var selected: Binding<NSMutableOrderedSet>?


    init(since: Date? = nil, until: Date? = nil,selected:Binding<NSMutableOrderedSet>? = nil) {
        let mode = selected == nil ? "view" : "edit"
        self.init(data: DataManager.writingManager.query(since: since, until: until), since: since, until: until,mode: mode,selected: selected)
    }

    init(data: [Writing], since: Date? = nil, until: Date? = nil, mode:String = "view",selected: Binding<NSMutableOrderedSet>? = nil) {
        self._mode = State(initialValue: mode)
        self._since = State(initialValue: since)
        self._until = State(initialValue: until)
        self._data = State(initialValue: data)
        self._weekSeqArray = State(initialValue: Array(WeekedSequence(data,selected: selected?.wrappedValue)))
        self.selected = selected
        // set initial selection state
//        if let s = selected {
//            print("onInit, selected = \(selected?.wrappedValue)")
//            for i in 0..<self.weekSeqArray.count {
////                self._weekSeqArray.wrappedValue[i].selected = s.wrappedValue.contains(self.weekSeqArray[i].writing.id)
//                self.weekSeqArray[i].selected.toggle()
////                        = s.wrappedValue.contains(self.weekSeqArray[i].writing.id)
//            }
//        }
    }

    //    init(since:Date? = nil, until:Date? = nil){
    //        self.since = since
    //        self.until = until
    //        self.data = [Writing]()
    //        self.weekSeqArray = [WeekstartAndItem]()
    ////        let data = DataManager.writingManager.query(since: since, until: until)
    ////        self.data = data
    ////        self.weekSeqArray = Array(WeekedSequence(data))
    //    }

    //    init(data:[Writing]){
    //
    //        self.data = [Writing]()
    //        self.weekSeqArray = [WeekstartAndItem]()
    ////        self.data = data
    ////        self.weekSeqArray = Array(WeekedSequence(self.data))
    //    }


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


    var body: some View {
        VStack {
            HStack {
                Spacer()
                if showEditSwitch {
                    Button(action: {
                        if self.mode == "edit" {
                            self.mode = "view"
                        } else {
                            self.mode = "edit"
                        }
                    }) {
                        Text("Switch \(self.mode == "edit" ? "view" : "edit")")
                    }
                }

                Button(action: {
                    self.refreshData()
                }) {
                    Text("Refresh")
                }
                if self.mode == "view" {
                    NavigationLink(destination: WriterView()) {
                        Text("Write")
                    }
                    NavigationLink(destination: MiscListView()) {
                        Text("More")
                    }
                }


            }.padding(Edge.Set.trailing, CGFloat(20.0))
            List {
                ForEach(Array(self.weekSeqArray.enumerated()), id: \.element.id) { (idx,_) in
                    Group {
                        // show title, content, and time
                        if self.mode == "edit" {
                            self.writingRow(idx: idx).onTapGesture {
                                self.setEditItemSelection(index: idx)
                            }
                        } else {
                            self.writingRow(idx: idx)
                        }
                    }

                }
                        .padding(.trailing, CGFloat(1))
            }
            //            .padding(.trailing,1)
        }.onAppear(perform: {
        }).onDisappear(perform: {
            if self.mode == "edit" {
                self.mode = "view"
            }
        })
    }

    func writingRow(idx: Int) -> some View {
        VStack(alignment: .leading) {
            HStack {
                if self.weekSeqArray[idx].contextualType == NoteContextualType.WEEK_BEGINNING {
                    Text(WritingList.formatLeadingDate(self.weekSeqArray[idx].writing.date, week: self.weekSeqArray[idx].week))
                            .background(Color.blue)
                } else if self.weekSeqArray[idx].contextualType == NoteContextualType.DAY_BEGINNING {
                    Text(WritingList.formatOrdinaryDate(self.weekSeqArray[idx].writing.date, week: self.weekSeqArray[idx].week))
                }
                Spacer()
            }


            if self.mode == "view" {
                NavigationLink(destination: WritingDetailView(writing: self.weekSeqArray[idx].writing)) {
                    Text(self.weekSeqArray[idx].writing.content)
                            .fontWeight(.semibold)
                }
            } else {
                // TODO must be struct to take effect, I do know why
                Text(self.weekSeqArray[idx].writing.content)
                        .fontWeight(.semibold)
                        .background(self.weekSeqArray[idx].selected ? Color.orange : Color.clear)


                //
            }

            Text(WritingList.formatTime(self.weekSeqArray[idx].writing.date))
                    .font(.system(size: 15))
                    .italic()
                    .fontWeight(.ultraLight)
                    .foregroundColor(.gray)

        }
                .frame(alignment: Alignment.leading)

    }

    // this get called
    //    func onAppear(perform action: (() -> Void)? = nil) -> some View
    //    {
    //        print("sub appeared")
    //        action?()
    //        return self
    //    }

    func refreshData() {
        self.data = self.queryData()
    }

    /*
     * to avoid modifying data refreshing views
     */
    func queryData() -> [Writing] {
        return DataManager.writingManager.query(since: self.since, until: self.until)
    }


    func setEditItemSelection(index: Int) {
        // selected in edit mode must have value
        if self.weekSeqArray[index].selected {
            self.selected!.wrappedValue.remove(self.weekSeqArray[index].writing.id)
            self.weekSeqArray[index].selected = false
        } else {
            self.selected!.wrappedValue.add(self.weekSeqArray[index].writing.id)
            self.weekSeqArray[index].selected = true
        }
    }

    static func formatLeadingDate(_ date: Date, week: Int) -> String {
        return "\(DateUtils.format(date, format: WritingList.YYYY_MM_DD))·\(WritingList.WEEK_NAMES[DateUtils.getWeekdaySinceMonday(date)]) 第\(week + 1)/\(DateUtils.getWeekCountOfYear(date))周 第\(DateUtils.getDayOfYear(date) + 1)天"
    }

    static func formatOrdinaryDate(_ date: Date, week: Int) -> String {
        return "\(DateUtils.format(date, format: WritingList.YYYY_MM_DD))·\(WritingList.WEEK_NAMES[DateUtils.getWeekdaySinceMonday(date)])"
    }

    static func formatTime(_ date: Date) -> String {
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
        WritingList(data: [
            Writing(id: 1, content: "I created a new content", date: DateUtils.parseDatetime("2019-10-01 09:10:00")!),

            Writing(id: 2, content: "I Updated some content", date: DateUtils.parseDatetime("2019-10-02 09:13:00")!),
            Writing(id: 3, content: "I Updated some content also", date: DateUtils.parseDatetime("2019-10-02 09:15:00")!),

            Writing(id: 4, content: "I Updated some content also Loooooooooooooooooooooooooooooooooooooong Cooooooooooooooooooooontent", date: DateUtils.parseDatetime("2019-10-02 09:15:00")!)
        ])
    }
}
