//
//  ShortLog.swift
//  X
//
//  Created by mac on 10/24/19.
//  Copyright © 2019 snu2017. All rights reserved.
//

import SwiftUI

struct ShortLog: View {
    
    @State var brief:String = ""
    
    var body: some View {
        Text(brief)
            .lineLimit(10)
    }
}

struct ShortLog_Previews: PreviewProvider {
    static var previews: some View {
        ShortLog(brief: "Brief word")
    }
}
