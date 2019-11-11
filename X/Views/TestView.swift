//
//  TestView.swift
//  X
//
//  Created by xhd2015 on 2019/11/2.
//  Copyright © 2019 snu2017. All rights reserved.
//

import SwiftUI

struct TestView: View {
    
    //    var viewList = [
    //        "CoreData Test":CoreDataTestView()
    //
    //    ]
    
    var body: some View {
        VStack{
            //                Text("Test")
            List{
                //                ForEach(Array(viewList.values)){ e in
                //            NavigationLink(destination:self.viewList[e]){
                //                        Text(e)
                //                    }
                //
                //                }
                NavigationLink(destination: CoreDataTestView()){
                    Text("CoreData Test")
                }
                
                NavigationLink(destination: SqliteRawTestView()){
                    Text("Sqlite Raw Test")
                }
                
                
                NavigationLink(destination: SqliteTestView()){
                    Text("Sqlite Test")
                }
                
                NavigationLink(destination:TestViewListView()){
                    Text("View Test")
                }
                
            }
            Spacer()
        }
        .navigationBarTitle("Test")
        
    }
    //        .frame(alignment: Alignment.top)
    
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        
        NavigationView {
            TestView()
        }
    }
}
