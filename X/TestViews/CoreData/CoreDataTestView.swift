//
//  CoreDataTestView.swift
//  X
//
//  Created by xhd2015 on 2019/11/2.
//  Copyright © 2019 snu2017. All rights reserved.
//

import SwiftUI

struct CoreDataTestView: View {
    
    @State var content = ""
    @State var loadContent = ""
    @State var showAlertLoading = false
    
    var body: some View {
        VStack{
            HStack{
                Spacer()
            }.frame(height:10)
            HStack{
                Text("Content:")
                    .foregroundColor(.orange)
                TextField("Some Content", text: self.$content)
                
            }
            HStack {
                Spacer()
                Button(action:{
                    self.saveData()
                }){
                    Text("Save Data")
                }
                Text("  ")
                Button(action:{
                    self.loadData()
                    //                    self.showAlertLoading = true
                }){
                    Text("Load Data")
                }
                //                .alert(isPresented: self.$showAlertLoading){
                //                    Alert(title: Text("The content"),message: Text(self.loadContent),dismissButton: Alert.Button.default(Text("OK")))
                //                }
                Spacer()
                
            }
            HStack {
                Text("Content Loaded").foregroundColor(.orange)
                TextField("", text: self.$loadContent)
                
            }
            Spacer()
            
        }.frame(alignment: Alignment.top)
    }
    

    //
    func saveData(){
        try! CoreDataManager.share.saveContent(content: self.content)
    }
    
    func loadData(){
        let contents = CoreDataManager.share.loadContent()
        
        if contents.count > 0{
            self.loadContent = contents.map({e in
                e.content!
                }).joined(separator: ",")
        }else{
            self.loadContent = "No Content Load"
        }
        
    }
}

struct CoreDataTestView_Previews: PreviewProvider {
    static var previews: some View {
        CoreDataTestView()
    }
}
