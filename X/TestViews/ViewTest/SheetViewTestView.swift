//
// Created by xhd2015 on 2019/11/10.
// Copyright (c) 2019 snu2017. All rights reserved.
//

import Foundation
import SwiftUI


struct SheetViewTestView: View {
    @State var showModal: Bool = false
    var body: some View {
        Text("show modal")
                .onTapGesture {
                    self.showModal = true
                }
                .sheet(isPresented: self.$showModal, onDismiss: {
                    print("onDismiss")
                }) {
                    NavigationView {
                        Text("Modal content").navigationBarItems(trailing:
                        Text("Done").onTapGesture {
                            print("Done pressed")
                            self.showModal = false
                        }
                        )
                    }
                }
    }
}

struct SheetViewTestView_Previews: PreviewProvider {
    static var previews: some View {
        SheetViewTestView()
    }
}