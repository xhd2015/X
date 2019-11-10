//
// Created by xhd2015 on 2019/11/9.
// Copyright (c) 2019 snu2017. All rights reserved.
//

import Foundation

class CacheWrapper {
    var writing:Writing?
    var born:Int = DateUtils.currentTimeInSeconds()

    init(writing:Writing?){
        self.writing = writing
    }
}

class CacheManager {

    static let instance:CacheManager = CacheManager()

    var cache:[Int64:CacheWrapper] = [Int64:CacheWrapper]()
    var life:Int = 600


    func getWriting(id:Int64,forceFlush:Bool = false) -> Writing? {
        if !forceFlush {
            let now = DateUtils.currentTimeInSeconds()
            if let wrapper = cache[id] {
                let span = now - wrapper.born
                if span < self.life {
                    return wrapper.writing
                }
            }
        }
        // requires flush
        let wrapper = self.query(id: id)
        cache[id] = CacheWrapper(writing: wrapper)
        return wrapper
    }

    func invalidate(id:Int64) {
        cache.removeValue(forKey: id)
    }

    fileprivate func query(id:Int64) -> Writing? {
        return DataManager.writingManager.query(id: id)
    }

}