//
//  TextViewTestView.swift
//  X
//
//  Created by xhd2015 on 2019/11/7.
//  Copyright © 2019 snu2017. All rights reserved.
//

import SwiftUI

struct TextViewTestView: View {
    var body: some View {
        List{
            Text("large title")
                .font(.largeTitle)
            
            Text("headline")
                .font(.headline)
            Text("subheadline")
                .font(.subheadline)
            
            Text("title")
                .font(.title)
            
            
            Text("caption")
                .font(.caption)
            
            Text("callout")
                .font(.callout)
            
            Group {
                Text("normal")
                
                Text("footnote")
                    .font(.footnote)
                
                Text("bold")
                    .bold()
                
                Text("italic")
                    .italic()
                
                Text("underline")
                    .underline()
                
                Text("background=Color.blue")
                    .background(Color.blue)
            }
        }
    }
}

struct TextViewTestView_Previews: PreviewProvider {
    static var previews: some View {
        TextViewTestView()
    }
}
