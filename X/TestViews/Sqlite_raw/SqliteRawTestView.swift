//
//  SqliteTestView.swift
//  X
//
//  Created by xhd2015 on 2019/11/3.
//  Copyright © 2019 snu2017. All rights reserved.
//

import SwiftUI

struct SqliteRawTestView: SwiftUI.View {
    
    @State var sql:String = ""
    @State var result:String = ""
    @State var error:String = ""
    
    var sqliteManager:SqliteManager
    
    init(){
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
        ).first!
        sqliteManager = SqliteManager(dbPath: path + "/my.sqlite3.db")
    }
    
    var body: some View {
        VStack{
            HStack{
                Text("SQL:")
                TextField("SELECT * FROM sqlite_master",text: self.$sql) .multilineTextAlignment(TextAlignment.leading)
                Spacer()
            }
            Divider()
            HStack{
                Button(action:{
                    self.query()
                }){
                    Text("Query")
                }
                .border(Color.black, width: 0.3)
                Text("|")
                
                Button(action:{
                    self.execute()
                }){
                    Text("Execute")
                }
                .border(Color.black, width: 0.3)
                Text("|")
                
                Button(action:{
                    self.clear()
                }){
                    Text("Clear")
                }.border(Color.black, width: 0.3)
            }
            Divider()
            HStack{
                Text("Result:")
            TextField("Result:", text: self.$result)
            }
            Divider()
            if error.count > 0 {
                Text(error)
                    .foregroundColor(.red)
            }
            Spacer()
        }
    }
    
    func query(){
        if(!self.checkSql()){
            return
        }
        
        let res = self.sqliteManager.queryMany(self.sql,errorHandler: self.handleError)
        
        if res.isEmpty {
            setError(msg: "Empty result")
        }else{
            var resArr = [String]()
            for  r in res{
                resArr.append(r.description)
            }
            self.result = resArr.joined(separator: ";")
        }
        
    }
    func execute(){
        if(!self.checkSql()){
            return
        }
        self.sqliteManager.exec(self.sql,errorHandler: self.handleError)
        self.result = "Execute succeed"
        
    }
    func clear(){
        self.result = ""
        self.clearError()
    }
    func setError(msg:String){
        self.error = msg
    }
    func clearError(){
        self.error = ""
    }
    func checkSql() -> Bool{
        self.clear()
        if self.sql.count == 0 {
            self.setError(msg:"Requires sql")
            return false
        }else{
            return true
        }
    }
    func handleError(_ e:Error) -> Void {
        self.setError(msg: "Error:" + e.localizedDescription)
    }
}

struct SqliteRawTestView_Previews: PreviewProvider {
    static var previews: some View {
        SqliteRawTestView()
    }
}
