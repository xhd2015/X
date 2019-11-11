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
    
    
    enum FilterDateMode: String, CaseIterable {
        case THIS_WEEK = "This Week"
        case THIS_MONTH = "This Month"
        case THIS_SEASON = "This Season"
        case THIS_YEAR = "This Year"
        case THE_FUTURE = "The Future"
        case EVER_SINCE = "Ever Since"
        case DATE_BETWEEN = "Date Between"
    }
    
    // view state
    //    normal state -> item clickable -> clicked -> detail view
    //    edit state -> item selectable -> selected/cancel
    //    onAppear && set edit state
    //    onDisappear && set non-edit state
    // problem: do not change
    //    @Environment(\.keyboardHeight) var keyboardHeight: CGFloat
    
    @State var showFilterBox: Bool = true
    // watch on this field with @State not working
    // computed not working
    @State var filterDateMode: FilterDateMode
    
    // computed properties is getting during view updating,so you cannot mutate fields
    //    var updatingMode:String {
    //        return self.filterDateMode.rawValue
    //    }
    
    @State var showDatePicker: Bool = false
    @State var filterBegin: String
    @State var filterEnd: String
    @State var filterTags: String // tag list separated by space
    @State var filterContent: String = ""
    
    var filterTagList: [String] {
        return self.filterTags.split(separator: " ").map({ $0.trimmingCharacters(in: .whitespacesAndNewlines) })
    }
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
    @State var showAlert:Bool = false
    @State var alertMsg: String = ""
    /*
     * assert the data are sorted by date already
     */
    //    @State
    @State var data: [Writing] {
        didSet {
            self.weekSeqArray = Array(WeekedSequence(data, selected: self.selected?.wrappedValue))
        }
    }
    @State var weekSeqArray: [WeekstartAndItem]
    var selected: Binding<NSMutableOrderedSet>?
    
    
    init(since: Date? = nil, until: Date? = nil, selected: Binding<NSMutableOrderedSet>? = nil,tags:[String]? = nil,filterDateMode:FilterDateMode = .DATE_BETWEEN) {
        let mode = selected == nil ? "view" : "edit"
        var s:Date? = since
        var u:Date? = until
        if filterDateMode != .DATE_BETWEEN {
            (u,s) = WritingList.getBeginEnd(mode: filterDateMode)
        }
        let queryData = DataManager.writingManager.query(since: u, until: s,tags: tags)
        self.init(data: queryData, since: since, until: until, mode: mode, selected: selected,tags:tags,filterDateMode:filterDateMode)
    }
    
    init(data: [Writing], since: Date? = nil, until: Date? = nil, mode: String = "view", selected: Binding<NSMutableOrderedSet>? = nil,tags:[String]? = nil,filterDateMode:FilterDateMode = .DATE_BETWEEN) {
        self._filterDateMode = State(initialValue: filterDateMode)
        self._filterBegin =  State(initialValue: since != nil ? DateUtils.toDateTimeString(since!) : "")
        self._filterEnd =  State(initialValue: until != nil ? DateUtils.toDateTimeString(until!) : "")
        self._filterTags = State(initialValue:  tags != nil ? tags!.joined(separator: " ") : "")
        self._mode = State(initialValue: mode)
        self._since = State(initialValue: since)
        self._until = State(initialValue: until)
        self._data = State(initialValue: data)
        self._weekSeqArray = State(initialValue: Array(WeekedSequence(data, selected: selected?.wrappedValue)))
        self.selected = selected
        // set initial selection state : DO NOT WORK
        //        if let s = selected {
        //            print("onInit, selected = \(selected?.wrappedValue)")
        //            for i in 0..<self.weekSeqArray.count {
        ////                self._weekSeqArray.wrappedValue[i].selected = s.wrappedValue.contains(self.weekSeqArray[i].writing.id)
        //                self.weekSeqArray[i].selected.toggle()
        ////                        = s.wrappedValue.contains(self.weekSeqArray[i].writing.id)
        //            }
        //        }
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
    
    
    var body: some View {
        VStack {
            HStack {
                PopupContainer(label: Text("Customize").foregroundColor(.blue),
                               onDismiss: {
                                self.updateCustom()
                }
                ) {
                    self.filterBoxView()
                }
                
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
                ForEach(Array(self.weekSeqArray.enumerated()), id: \.element.id) { (idx, _) in
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
            .alert(isPresented: self.$showAlert){
                Alert(title: Text("Error"),message:
                    Text(self.alertMsg).foregroundColor(.red),
                      dismissButton: .default( Text("OK"),action:{
                        self.showAlert = false
                      }))
        }
    }
    
    func filterBoxView() -> some View {
        // use List to show complete label, VStack hides some leading characters
        List {
            HStack {
                //                Text("\(keyboardHeight)")
                Text("Quick Date:")
                Picker(selection: self.$filterDateMode, label: Text("Date")) {
                    ForEach(0..<FilterDateMode.allCases.count) { i in
                        Text(FilterDateMode.allCases[i].rawValue)
                            .tag(FilterDateMode.allCases[i])
                    }
                }
            }
            
            if self.filterDateMode == .DATE_BETWEEN {
                HStack(alignment: .center) {
                    Text("Date:")
                    TextField("From:", text: self.$filterBegin)
                    Text("To")
                    TextField("To:", text: self.$filterEnd)
                }
            }
            
            HStack {
                Text("Tags:")
                TextField("Tags:", text: self.$filterTags)
            }
            
            HStack {
                Text("Content:")
                TextField("Content:", text: self.$filterContent)
            }
            .modifier(KeyboardAdaptive())
            
            //            HStack(alignment: .center) {
            //                Button(action: {
            //                    self.refreshData()
            //                }) {
            //                    Text("Confirm")
            //                }
            //            }
        }
        //        .padding(.bottom, keyboardHeight)
        //                .frame(alignment: .center)
        //                .frame(width: 300)
        
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
        return DataManager.writingManager.query(since: self.since, until: self.until,tags: self.filterTagList,searchContent: self.filterContent)
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
    
    func updateCustom(){
        if self.filterDateMode == .DATE_BETWEEN {
            var errorMsg:String = ""
            if !self.filterBegin.isEmpty {
                if let since = DateUtils.parseDatetime(self.filterBegin){
                    self.since = since
                }else{
                    errorMsg = "Error date:" + self.filterBegin
                }
            }
            if errorMsg.isEmpty && !self.filterEnd.isEmpty {
                if let until = DateUtils.parseDatetime(self.filterEnd){
                    self.until = until
                }else{
                    errorMsg = "Error date:" + self.filterEnd
                }
            }
            if !errorMsg.isEmpty {
                self.setAlertShow(errorMsg)
                return
            }
        }else{
            let x = WritingList.getBeginEnd(mode: self.filterDateMode)
            self.since = x.start
            self.until = x.end
        }
        self.refreshData()
    }
    
    func setAlertShow(_ msg:String) {
        self.alertMsg = msg
        self.showAlert = true
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
    
    static func parseDate(_ text:String) throws -> Date? {
        if text.isEmpty {
            return nil
        }
        return DateUtils.parseDatetime(text)!
    }
    static func getBeginEnd(mode:FilterDateMode) -> (start:Date?,end:Date?) {
        let now = Date()
        var start:Date? = nil
        var end:Date? = nil
        switch mode {
            case .THIS_WEEK:
                start = DateUtils.toWeekMondayBegin(now)
                end = DateUtils.toWeekSundayEnd(now)
            case .THIS_MONTH:
                start = DateUtils.toMonthBegin(now)
                end = DateUtils.toMonthEnd(now)
            case .THIS_SEASON:
                start = DateUtils.toSeasonBegin(now)
                end = DateUtils.toSeasonEnd(now)
            case .THIS_YEAR:
                start = DateUtils.toYearBegin(now)
                end = DateUtils.toYearEnd(now)
            case .THE_FUTURE:
                start = DateUtils.toDateBegin(now)
            case .EVER_SINCE:
                DateUtils.pass()
            default:
                fatalError("Unexpected branch:\(mode)")
        }
        return (start:start,end:end)
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
