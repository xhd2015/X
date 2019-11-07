//
//  DateUtils.swift
//  X
//
//  Created by xhd2015 on 2019/11/5.
//  Copyright © 2019 snu2017. All rights reserved.
//

import Foundation
import SwiftUI

struct DateToolView: View {
    @State var begin:String = DateUtils.toDateTimeString(Date())
    @State var end:String =  DateUtils.toDateTimeString(DateUtils.toNextNoon(Date()))
    @State var result:String = ""
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                TextField("From:", text: $begin)
//                .textFieldStyle(.roundedBorder)
                
                Text("To")
                TextField("To:", text:$end)
//                .textFieldStyle(.roundedBorder)
            }
            Button(action:{
                self.result = self.describeDiffDate(from:self.begin,to:self.end)
            }){
                 Text("Calculate")
        }
            Text(self.result)
        }
    }
    
    func describeDiffDate(from:String,to:String) -> String{
        if let start = DateUtils.parseDatetime(from) {
            if let end = DateUtils.parseDatetime(to) {
                return describeDiff(timeInSeconds: Int(end.timeIntervalSince1970 - start.timeIntervalSince1970))
            }
        }
        return "错误"
    }
    
    // day, hour, minute, second
    func describeDiff(timeInSeconds:Int) -> String {
        var left = timeInSeconds
        let diffDays = left/(24*60*60)
        left = left%(24*60*60)
        let diffHours = left/(60*60)
        left = left%(60*60)
        let diffMinutes = left/60
        let diffSeconds = left%60
        if diffDays != 0 {
            return "\(diffDays)天\(diffHours)时\(diffMinutes)分\(diffSeconds)秒"
        }else if diffHours != 0 {
                return "\(diffHours)时\(diffMinutes)分\(diffSeconds)秒"
        }else if diffMinutes != 0 {
            return "\(diffMinutes)分\(diffSeconds)秒"
        }else{
            return "\(diffSeconds)秒"
        }
    }
    
}

struct DateToolView_Previews: PreviewProvider {
    static var previews: some View {
        DateToolView()
    }
}
