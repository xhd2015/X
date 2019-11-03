//
//  ContentView.swift
//  X
//
//  Created by mac on 10/23/19.
//  Copyright © 2019 snu2017. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var selection = 0
    
    
    // embed a test-purepose tool inside it
    // easy to invoke that test
    // it should be a 
    var body: some View {
        
        NavigationView{
            
            List{
                
                NavigationLink(destination: TestView()){
                    Text("Test")
                }
                NavigationLink(destination: WriterView()){
                    Text("Write")
                }
                
                
                NavigationLink(destination:
                    WritingList(data:
                        DataManager.writingManager.querySince(since: DateUtils.toWeekMondayBegin())
                        
//                        [
//                        Writing(id:1, content:"I craeted a new content",date:DateUtils.parseDatetime("2019-10-01 09:10:00")!),
//
//                        Writing(id:2, content:"I Updated some content",date:DateUtils.parseDatetime("2019-10-02 09:13:00")!)
//                    ]
                    )
                    
                ){
                    Text("List")
                }
                
                
            }
            
        }        //        TabView(selection: $selection){
        //            Text("First View")
        //                .font(.title)
        //                .tabItem {
        //                    VStack {
        //                        Image("first")
        //                        Text("First")
        //                    }
        //                }
        //                .tag(0)
        //            Text("Second View")
        //                .font(.title)
        //                .tabItem {
        //                    VStack {
        //                        Image("second")
        //                        Text("Second")
        //                    }
        //                }
        //                .tag(1)
        //        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
