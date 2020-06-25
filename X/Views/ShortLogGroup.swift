//
//  ShortLogGroup.swift
//  X
//
//  Created by mac on 10/24/19.
//  Copyright © 2019 snu2017. All rights reserved.
//

import SwiftUI

struct ShortLogGroup: View {
    
    @State var title:String
    @State var logList:[String] = [String]()
    
    
    var body: some View {
        NavigationView{
            List{
                ForEach(logList,id:\.self){log in
                    ShortLog(brief: log)
                }
            }
            .navigationBarTitle(
                Text(title)
                    .font(.custom("myCustom", size: 3)))
        
        }
    }
}

struct ShortLogGroup_Previews: PreviewProvider {
    static var previews: some View {
        ShortLogGroup(title:"Some Logs",logList:["A","B","C"])
    }
}
