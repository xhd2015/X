//
//  ShortLogGroupList.swift
//  X
//
//  Created by mac on 10/24/19.
//  Copyright © 2019 snu2017. All rights reserved.
//

import SwiftUI

struct ShortLogGroupList: View {
    
    @State var logGroups:[LogModel]
    
    var body: some View {
        List{
            ForEach(self.logGroups){ logModel in
                if logModel is DateSeparator{
                    Text((logModel as! DateSeparator).date).foregroundColor(.blue)
                }else if logModel is ShortLogModel {
                    NavigationLink(destination: ShortLog(brief: "Link")){
                        Text((logModel as! ShortLogModel).content)
                        
                    }
                }else if logModel is BlogModel {
                    NavigationLink(destination: ShortLog(brief: "Link")){
                        VStack{
                            Text((logModel as! BlogModel).title)
                                .font(.largeTitle)
                            Text((logModel as! BlogModel).content)
                                .font(.body)
                        }
                    }
                    
                    
                }else{
                    Text("Unknown type")
                }
                
            }
        }
    }
}

struct ShortLogGroupList_Previews: PreviewProvider {
    static var previews: some View {
        ShortLogGroupList(logGroups:[
            DateSeparator("2019-10-25"),
            ShortLogModel("hello world"),
            DateSeparator("2019-10-26"),
            BlogModel(title:"hello", content:"my name is nothing")
        ])
        //        ShortLogGroupList(logGroups: ["A":["A"]])
    }
}
