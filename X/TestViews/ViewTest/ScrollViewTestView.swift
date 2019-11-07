//
//  ScrollViewTestView.swift
//  X
//
//  Created by xhd2015 on 2019/11/6.
//  Copyright © 2019 snu2017. All rights reserved.
//

import SwiftUI

struct ScrollViewTestView: View {
    var body: some View {
        ScrollView {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            Text("Bizaer")
        }
        
    }
}

struct ScrollViewTestView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollViewTestView()
    }
}
