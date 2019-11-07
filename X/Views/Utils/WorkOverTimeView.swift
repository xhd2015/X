//
//  WorkOverTimeView.swift
//  X
//
//  Created by xhd2015 on 2019/11/6.
//  Copyright © 2019 snu2017. All rights reserved.
//

import SwiftUI

struct WorkOverTimeView: View {
    
    @State var showSettings:Bool = true
    @State var begin:String = "09:30"
    @State var end:String = DateUtils.format(Date(), format: DateUtils.HH_MM)
    @State var excludeGroups:[TimePair] = [
        TimePair(begin:  "12:15", end: "14:00"),
        TimePair(begin:  "18:15", end: "19:00"),
    ]
    
    @State var result:String = ""
    
    
    var body: some View {
        VStack{
            Text("Settings").onTapGesture{
                self.showSettings.toggle()
            }
            if self.showSettings {
                List(0..<excludeGroups.count,id:\.self){ i in
                    HStack {
                        Text("Exclude")
                        Divider()
                        TextField("From",text: self.$excludeGroups[i].begin)
                        Text("To")
                        TextField("To",text:self.$excludeGroups[i].end)
                    }
                    //
                }
                   .frame(height:80)
            }
            Divider()
            
            VStack {
                HStack(alignment: .center) {
                    TextField("From", text: $begin)
                    
                    Text("To")
                    TextField("To", text:$end)
                }
                Button(action:{
                    self.calculate()
                }){
                    Text("Calculate")
                }
                Text(self.result)
            }
            Spacer()
            
        }
    }
    
    func calculate(){
        self.result = ""
        if let start = TimePoint(text:self.begin) {
            if let end = TimePoint(text:self.end) {
                var startMinute = start.toMinutes()
                var endMinute  = end.toMinutes()
                if endMinute < startMinute {
                    endMinute += 24*60
                }
                var sum = 0
                // time point
                var error = false
                var completed = false
                for e in excludeGroups {
                    if let mstart = e.beginPoint?.toMinutes() {
                        
                    
                        if let mend = e.endPoint?.toMinutes() {
                            
                            // check range
                            if mstart > mend {
                                error = true
                                break
                            }

                            if startMinute >= mstart {
                                if endMinute < mend {
                                    completed = true
                                    break
                                }
                                if startMinute < mend {
                                     startMinute = mend
                                }
                                continue
                            }
                            
                            if endMinute <= mstart {
                                sum += endMinute - startMinute
                                completed = true
                                break
                            }
                            
                            sum += mstart - startMinute
                            
                            startMinute = mend
                            
                            if startMinute >= endMinute {
                                completed = true
                                break
                            }
                            
                        }else{
                            error = true
                            break
                        }
                    }else{
                        error = true
                        break
                    }
                }
                if !error {
                    if !completed && endMinute >= startMinute {
                        sum += endMinute - startMinute
                    }
                    self.result = "\(sum/60)时\(sum%60)分"
                    return
                }
            }
        }
        self.result = "错误"
    }
}

struct WorkOverTimeView_Previews: PreviewProvider {
    static var previews: some View {
        WorkOverTimeView(showSettings:true)
    }
}
