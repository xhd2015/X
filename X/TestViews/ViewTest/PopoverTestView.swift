//
// Created by xhd2015 on 2019/11/10.
// Copyright (c) 2019 snu2017. All rights reserved.
//

import Foundation
import SwiftUI


struct PopoverTestView: View {
    @State var showPopover: Bool = false

    var body: some View {
        Text("show popover")
                .onTapGesture {
                    self.showPopover = true
                }
                .popover(isPresented: self.$showPopover){
                    NavigationView {
                        Text("Modal content").navigationBarItems(trailing:
                        Text("Done").onTapGesture {
                            print("Done pressed")
                            self.showPopover = false
                        }
                        )
                    }
                }
    }
}

struct PopoverTestView_Previews: PreviewProvider {
    static var previews: some View {
        PopoverTestView()
    }
}