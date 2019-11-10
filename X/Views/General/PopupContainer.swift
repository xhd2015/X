//
// Created by xhd2015 on 2019/11/10.
// Copyright (c) 2019 snu2017. All rights reserved.
//

import Foundation
import SwiftUI


struct PopupContainer<Label,Content>: View  where Content:View,Label:View{

    @State var showContent: Bool = false {
        didSet {
            if let s = self.show {
                s.wrappedValue = self.showContent
            }
        }
    }

    let show:Binding<Bool>?
    let label:Label
    let content:()->Content
    var onDismiss: ()->Void
    var onShow:()->Void


    init(label:Label,show:Binding<Bool>? = nil, onShow: @escaping ()->Void = {}, onDismiss: @escaping ()->Void = {},@ViewBuilder content: @escaping () -> Content ){
        self.show = show
        self.label = label
        self.content = content
        self.onDismiss = onDismiss
        self.onShow = onShow
        if let s = show {
            s.wrappedValue = self.showContent
        }
    }

    var body: some View {
        self.label.onTapGesture{
                    self.showContent = true
                }
                .sheet(isPresented: self.$showContent, onDismiss: {
                    self.onDismiss()
                }) {
                    NavigationView {
                        self.content().navigationBarItems(trailing:
                        Text("Done").onTapGesture {
                            self.showContent = false
                            self.onShow()
                        }
                        )
                    }
                }
    }
}

struct PopupContainer_Previews: PreviewProvider {
    static var previews: some View {
        PopupContainer(label:Text("Popup")){
            Text("Content")
        }
    }
}