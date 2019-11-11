//
//  MiscListView.swift
//  X
//
//  Created by xhd2015 on 2019/11/6.
//  Copyright © 2019 snu2017. All rights reserved.
//

import SwiftUI

struct MiscListView: View {
    var body: some View {
        List{
            
            NavigationLink(destination:WritingList(tags:["constant"],filterDateMode:.EVER_SINCE)){
                Text("Constant")
            }
            NavigationLink(destination: TestView()){
                Text("Test")
            }
//            NavigationLink(destination: WriterView()){
//                Text("Write")
//            }
            
//            NavigationLink(destination:
//                WritingList(
//                    since:DateUtils.toWeekMondayBegin()
                    //
                    //                        data:nil
                    //                        data:[
                    //                            Writing(id:1, content:"I craeted a new content",date:DateUtils.parseDatetime("2019-10-01 09:10:00")!),
                    //
                    //                            Writing(id:2, content:"I Updated some content",date:DateUtils.parseDatetime("2019-10-02 09:13:00")!)
                    //                        ]
                    
//                )
                
                
                // onAppear can be repeated invoked
                // onAppear only gets called during application life cycle
                //                        .onAppear(perform:{
                //                            self.writingList = DataManager.writingManager.query(since: DateUtils.toWeekMondayBegin())
                //                            print("appeared")
                //                        })
                
                //                    .onAppear(perform: {
                //                        print("onAppeared2")
                //                    })
                
//            ){
//                Text("List")
//            }
            
            NavigationLink(destination: DateToolView()){
                Text("Date Tools")
            }
            
            NavigationLink(destination: WorkOverTimeView()){
                Text("Work Time Tools")
            }
        }
    }
}

struct MiscListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            MiscListView()
        }
    }
}
