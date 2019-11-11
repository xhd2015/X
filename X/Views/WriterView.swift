//
//  WriterView.swift
//  X
//
//  Created by mac on 10/23/19.
//  Copyright © 2019 snu2017. All rights reserved.
//

import SwiftUI

struct WriterView: View {
    
    enum DateMode:String,CaseIterable {
        case DEFAULT = "Default"
        case PICK_ONE = "Pick One"
        case CUSTOM = "Custom"
    }
    
    @State var text:String = ""
    @State var showDatePicker:Bool = false
    
    @State var customDate:DateMode = .DEFAULT
    @State var date:Date = Date()
    @State var dateString:String = DateUtils.toDateTimeString(Date())
    
    @State var showAlert:Bool = false
    @State var alertMessage:String = ""
    
    var calDate:Date? {
        switch self.customDate {
            case .DEFAULT:
                return Date()
            case .PICK_ONE:
                return date
            case .CUSTOM:
                return DateUtils.parseDatetime(self.dateString)
            default:
                return nil
        }
    }
    
    var body: some View {
        ScrollView{
            VStack{
                TextView(text:self.$text)
                    .frame(height:300)
                Divider()
                HStack{
                    Button(action:{
                        self.confirm()
                    }){
                        Text("Confirm")
                            .border(Color.black, width: CGFloat(0.3))
                    }
                }.alert(isPresented: self.$showAlert){
                    Alert(title: Text("Error"), message: Text(self.alertMessage), dismissButton: .cancel(Text("OK"),action:{self.showAlert = false}))
                }
                HStack {
                    Text("Options\(showDatePicker ? "▼" : "▶")")
                        .onTapGesture {
                            self.showDatePicker.toggle()
                    }
                    Spacer()
                }
                if self.showDatePicker {
                    Divider()
                    HStack{
                        Text("Custom:")
                        Picker(selection: self.$customDate, label: Text("Custom:")){
                            ForEach(0..<DateMode.allCases.count){ i in
                                Text(DateMode.allCases[i].rawValue).tag(DateMode.allCases[i])
                            }
                        }.pickerStyle(SegmentedPickerStyle())
                    }
                    if self.customDate == DateMode.PICK_ONE {
                        HStack{
                            DatePicker(selection: self.$date) {
                                Text("Date:")
                            }
                        }
                    }else if self.customDate == DateMode.CUSTOM {
                        HStack{
                            TextField("", text: self.$dateString)
                        }.modifier(KeyboardAdaptive())
                    }
                }
                Spacer()
            }
        }
    }
    
    func confirm(){
        if self.text.isEmpty {
            self.setAlertShown(message: "Content must not be empty!")
            return
        }
        let calDate = self.calDate
        if calDate == nil {
            self.setAlertShown(message: "Invalid customized date!")
            return
        }
        let writing = Writing(content:self.text,date: calDate!)
        if DataManager.writingManager.insert(writing: writing){
            self.text = ""
        }
    }
    
    func setAlertShown(message:String) {
        self.alertMessage = message
        self.showAlert = true
    }
    
    //        VStack{
    //            // Binding<String> = $text, text must be @State
    //            TextField("A", text: self.$text)
    //                .foregroundColor(.red)
    //                .border(Color.blue,width: 1)
    //                //            .multilineTextAlignment(.leading)
    //                .lineLimit(nil)
    //
    //            Text(self.text)
    //                .border(Color.blue,width:1)
    //                .frame(width: 200)
    //        }
    
    //    }
}

struct WriterView_Previews: PreviewProvider {
    static var previews: some View {
        WriterView(text:"Hello TextView\nbb\ncc\ncc\nfff\ndsds")
    }
}


