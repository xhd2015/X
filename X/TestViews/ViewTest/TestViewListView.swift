//
//  TestViewListView.swift
//  X
//
//  Created by xhd2015 on 2019/11/6.
//  Copyright © 2019 snu2017. All rights reserved.
//

import SwiftUI

struct TestViewListView: View {
    var body: some View {
        List {
            NavigationLink(destination: ScrollViewTestView()){
                 Text("ScroolView")
            }
            
            NavigationLink(destination: TextViewTestView()){
                 Text("TextView")
            }

            NavigationLink(destination: SheetViewTestView()){
                Text("Sheet View")
            }


            NavigationLink(destination: PopoverTestView()){
                Text("Popover View")
            }
            
            NavigationLink(destination: TabTestView()){
                Text("Tab View")
            }






        }.navigationBarTitle("Test Views")
        
    }
}

struct TestViewListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
        TestViewListView()
        }
    }
}
