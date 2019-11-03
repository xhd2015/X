//
//  WriterView.swift
//  X
//
//  Created by mac on 10/23/19.
//  Copyright © 2019 snu2017. All rights reserved.
//

import SwiftUI

struct WriterView: View {
    
    @State var text:String = ""
    
    var body: some View {
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
            }
            Spacer()
        }
    }
    
    func confirm(){
        if self.text.isEmpty {
            return
        }
        let writing = Writing(content:self.text)
        if DataManager.writingManager.insert(writing: writing){
            self.text = ""
        }
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


