//
//  ContentView.swift
//  X
//
//  Created by mac on 10/23/19.
//  Copyright © 2019 snu2017. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    // embed a test-purepose tool inside it
    // easy to invoke that test
    // it should be a 
    var body: some View {
        NavigationView{
            VStack{
//                NavigationLink(destination: WriterView()){
//                    Text("Write")
//                }
//
                WritingList(since:DateUtils.toWeekMondayBegin())
                    //            .navigationBarHidden(true)
                    .navigationBarTitle("Happening", displayMode: .inline)
                    
                    // navigationLink inside bar will throw exception upon returing back
//                    .navigationBarItems(
//                        trailing:
//                        HStack{
                            //
                            //                        NavigationLink(destination: MiscListView()){
                            //                        Text("More")
                            //                        }
//                        NavigationView{
//                            NavigationLink(destination: WriterView()){
//                                Text("Write2")
//                            }
//                        }.navigationBarHidden(true)
//                        }
//                )
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
