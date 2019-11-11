//
//  TabTestView.swift
//  X
//
//  Created by xhd2015 on 2019/11/11.
//  Copyright © 2019 snu2017. All rights reserved.
//

import SwiftUI

struct TabTestView: View {
    @State var page:Int=0
    var body: some View {
        Group{
            Text("page=\(self.page)")
        TabView(selection: self.$page) {
            Text("The First Tab")
                .tabItem {
                    Image(systemName: "1.square.fill")
                    Text("First")
                }
            .tag(0)
            Text("Another Tab")
                .tabItem {
                    Image(systemName: "2.square.fill")
                    Text("Second")
                }
            .tag(1)
            Text("The Last Tab")
                .tabItem {
                    Image(systemName: "3.square.fill")
                    Text("Third")
                }
        .tag(2)
        }
        .font(.headline)
        }
    }
}

struct TabTestView_Previews: PreviewProvider {
    static var previews: some View {
        TabTestView()
    }
}
