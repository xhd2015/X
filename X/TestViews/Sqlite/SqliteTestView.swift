//
//  SqliteTestView.swift
//  X
//
//  Created by xhd2015 on 2019/11/3.
//  Copyright © 2019 snu2017. All rights reserved.
//

import SwiftUI

struct SqliteTestView: SwiftUI.View {
    @State var inputId:String = ""
    @State var sqliteModel:SqliteModel = SqliteModel()
    @State var error:String = ""
    @State var info:String = ""
    
    var sqliteManager:SqliteModelManager
    
    var userId:Int64 {
        return  Int64(self.inputId) ?? 0
    }
    
    init(){
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
        ).first!
        self.sqliteManager = SqliteModelManager(dbPath: "\(path)/sqliteModel.sqlite3.db")
        self.sqliteManager.errorHandler = self.handleError
    }
    
    var body: some View {
        VStack{
            VStack {
                Text("Model")
                List{
                    HStack{
                        Text("User Id:")
                        TextField("user id...",text: self.$inputId)
                    }
                    
                    HStack{
                        Text("User Name:")
                        TextField("user name...",text: self.$sqliteModel.userName)
                    }
                    
                    HStack{
                        Text("Sex:")
                        TextField("sex...",text: self.$sqliteModel.sex)
                    }
                    
                    HStack{
                        Text("Date:")
                        Text("\(self.sqliteModel.date)")
                    }
                }.frame(height:CGFloat(200.0))
            }
            Divider()
            HStack{
                Button(action:{
                    self.query()
                }){
                    Text("Query")
                }
                .border(Color.black, width: CGFloat(0.3))
                Text("|")
                
                Button(action:{
                    self.saveOrUpdate()
                }){
                    Text("Save or Update")
                }
                .border(Color.black, width: CGFloat(0.3))
                Text("|")
                
                Button(action:{
                    self.clear()
                }){
                    Text("Clear")
                }.border(Color.black, width: CGFloat(0.3))
            }
            Divider()
            if error.count > 0 {
                Text(error)
                    .foregroundColor(.red)
            }
            if info.count > 0 {
                Text(info)
                    .foregroundColor(.green)
            }
            Spacer()
        }
    }
    
    func query(){
        self.clear()
        self.sqliteModel.id = self.userId
        if !self.checkSql() {
            return
        }
        if let user = self.sqliteManager.queryUser(id: self.sqliteModel.id) {
            self.setInfo(msg: "id:\(user.id), name:\(user.userName), sex:\(user.sex), date:\(user.date)")
        }else{
            self.setError(msg:"No such user:\(self.sqliteModel.id)")
        }
        
        
        
        //        let res = self.sqliteManager.queryMany(self.sql,errorHandler: self.handleError)
        
        //        if res.isEmpty {
        //            setError(msg: "Empty result")
        //        }else{
        //            var resArr = [String]()
        //            for  r in res{
        //                resArr.append(r.description)
        //            }
        //            self.result = resArr.joined(separator: ";")
        //        }
        
    }
    func saveOrUpdate(){
        self.clear()
        self.sqliteModel.id = self.userId
        if self.inputId.isEmpty {
            // insert
            if sqliteManager.insertUser(sqliteModel: self.sqliteModel){
                self.setInfo(msg: "insert user successful,id =\(self.sqliteModel.id)")
            }
        }else{
            if self.sqliteModel.id <= 0 {
                self.setError(msg: "Id must be positive:\(self.sqliteModel.id)")
                return
            }
            if sqliteManager.updateUser(sqliteModel: self.sqliteModel){
                self.setInfo(msg: "update user successful")
            }
        }
        
    }
    func clear(){
        self.info = ""
        self.clearError()
    }
    func setError(msg:String){
        self.error = msg
    }
    func clearError(){
        self.error = ""
    }
    func setInfo(msg:String){
        self.info = msg
    }
    func clearInfo(){
        self.info = ""
    }
    func checkSql() -> Bool{
        if self.sqliteModel.id <= 0 {
            self.setError(msg:"Id must be positive:\(self.sqliteModel.id)")
            return false
        }else{
            return true
        }
        //        if self.sql.count == 0 {
        //            self.setError(msg:"Requires sql")
        //            return false
        //        }else{
        //            return true
        //        }
    }
    func handleError(_ e:Error) -> Void {
        self.setError(msg: "Error:" + e.localizedDescription)
    }
}

struct SqliteTestView_Previews: PreviewProvider {
    static var previews: some View {
        SqliteTestView()
    }
}
