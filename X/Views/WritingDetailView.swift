//
//  WritingDetailView.swift
//  X
//
//  Created by xhd2015 on 2019/11/6.
//  Copyright © 2019 snu2017. All rights reserved.
//

import SwiftUI

struct WritingDetailView: View {
    
    @State var writing:Writing
    @State var showAddingRemark:Bool = false
    @State var remarkEditContent:String = ""
    @State var remarks:[Remark]? = nil
    @State var showAlert:Bool = false
    @State var alertContent:String = ""
    
    @State var showAddingTag:Bool = false
    @State var tagEditContent:String = ""
    @State var tagMaps:[TagMap]? = nil
    
    // use computed to avoid updating model while updating view
    var requiredRemarks:[Remark] {
        if self.remarks == nil {
            return self.queryRemark()
        }
        return self.remarks!
    }
    var requiredTagMaps:[TagMap] {
        if self.tagMaps == nil {
            return self.queryTagMaps()
        }
        return self.tagMaps!
    }
    
    var remarkEdit:Remark {
        let now = Date()
        return Remark(
            remark : self.remarkEditContent,
            target : "writing",
            targetId : self.writing.id,
            createTime: now,
            updateTime: now
        )
    }
    
    var tagMapEdit:TagMap {
        return TagMap(
            targetId : self.writing.id,
            tagName : self.tagEditContent
        )
    }
    
    
    fileprivate func confirmAdd() {
        if self.remarkEditContent.isEmpty {
            self.alertContent = "Remark must not be empty"
            self.showAlert = true
            return
        }
        var remark = self.remarkEdit
        DataManager.remarkManager.insert(model: &remark)
        self.refreshTagMaps()
        self.showAddingTag = false
    }
    
    fileprivate func confirmAddTag(){
        if self.tagEditContent.isEmpty {
            self.alertContent = "Remark must not be empty"
            self.showAlert = true
            return
        }
        var model = self.tagMapEdit
        DataManager.tagMapManager.insert(model: &model)
        self.refreshTagMaps()
        self.showAddingTag = false
    }
    
    var body: some View {
        VStack(alignment:.leading) {
            //            Group {
            Text(writing.content)
                .frame(minHeight:100)
            
            Text(DateUtils.format(writing.date, format: DateUtils.YYYY_MM_DD_HH_MM_SS))
                .foregroundColor(.gray)
                .italic()
            
            Divider()
            
            List{
                
                Text("Tags")
                    .font(.subheadline)
                    .bold()
                    .underline()
                
                if !requiredTagMaps.isEmpty {
                    HStack {
                        ForEach(requiredTagMaps,id: \.id) { model in
                            // TODO: add remove support
                            Text(model.tagName)
                                .foregroundColor(.orange)
                        }
                    }
                }
                //.alert
                
                
                
                VStack {
                    if showAddingTag {
                        TextField("tag",text: $tagEditContent)
                            .frame(height:40)
                    }
                    
                    
                    if showAddingTag {
                        
                        HStack {
                            Button("Confirm",action:{})
                                .onTapGesture{
                                    self.confirmAddTag()
                            }
                            
                            Divider()
                            
                            Button("Cancel",action:{})
                                .onTapGesture{
                                    self.showAddingTag = false
                            }
                            
                            //                            Divider()
                            
                        }
                    }else{
                        
                        Button(action:{
                            self.tagEditContent = ""
                            self.showAddingTag = true
                        }){
                            Text("Add Tag")
                                .foregroundColor(.blue)
                                .underline()
                        }
                    }
                }
                //            }
                //            List  {
                //                NavigationLink(destination:Text("Link")){
                //                    Text("Mima")
                //                }
                //            }
                Text("Links")
                    .font(.subheadline)
                    .bold()
                    .underline()
                //            List {
                //                NavigationLink(destination:Text("Link")){
                //                    Text("Mima")
                //                }
                //            }
                Text("Remarks")
                    //                .foregroundColor(.orange)
                    .font(.subheadline)
                    .bold()
                    .underline()
                //                .background(Color.yellow)
                ForEach(requiredRemarks,id: \.id) { remark in
                    VStack{
                        Text(remark.remark)
                        
                        
                        Text(DateUtils.format(remark.updateTime, format: DateUtils.YYYY_MM_DD_HH_MM_SS))
                            .foregroundColor(.gray)
                            .italic()
                        
                    }
                }
                
                VStack {
                    if showAddingRemark {
                        TextField("remark",text: $remarkEditContent)
                            .frame(height:40)
                    }
                    
                    
                    if showAddingRemark {
                        
                        HStack {
                            Button("Confirm",action:{})
                                .onTapGesture{
                                    self.confirmAdd()
                            }
                            
                            Divider()
                            
                            Button("Cancel",action:{})
                                .onTapGesture{
                                    self.showAddingRemark = false
                            }
                            
                            //                            Divider()
                            
                        }
                    }else{
                        Button(action:{
                            self.remarkEditContent = ""
                            self.showAddingRemark = true
                        }){
                            Text("Add Remark")
                                .foregroundColor(.blue)
                                .underline()
                        }
                    }
                }
                
                
            }.alert(isPresented: self.$showAlert) {
                Alert(title:Text("Error"),message:Text(self.alertContent)
                    ,dismissButton: Alert.Button.cancel(Text("OK")){
                        self.showAlert = false
                    }
                )
            }
            
            //            }
            Spacer()
        }
    }
    
    func refreshRemark() {
        self.remarks = self.queryRemark()
    }
    
    func refreshTagMaps() {
        self.tagMaps = self.queryTagMaps()
    }
    
    func queryRemark () -> [Remark]{
        return DataManager.remarkManager.query(writingId: writing.id)
    }
    
    func queryTagMaps () -> [TagMap]{
        return DataManager.tagMapManager.query(writingId: writing.id)
    }
}

struct WritingDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            WritingDetailView(writing: Writing(id:1,content: "Hash code",date: Date()), showAddingRemark:true)
        }
    }
}
