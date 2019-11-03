//
//  MyNumberFormatter.swift
//  X
//
//  Created by xhd2015 on 2019/11/3.
//  Copyright © 2019 snu2017. All rights reserved.
//

import Foundation


class MyNumberFormatter : NumberFormatter {
    
      
    override func string(from number: NSNumber) -> String? {
        let res = super.string(from: number)
        debugPrint("calling formatter::string(\(number))")
        return res
    }
    
    

        

        
    override func attributedString(for obj: Any, withDefaultAttributes attrs: [NSAttributedString.Key : Any]? = nil) -> NSAttributedString? {
        return super.attributedString(for: obj, withDefaultAttributes: attrs)
    }

        
    override func editingString(for obj: Any) -> String? {
        return super.editingString(for: obj)
    }

        
        override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string: String, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
            return super.getObjectValue(obj, for: string, errorDescription: error)
        }
        
    override func isPartialStringValid(_ partialString: String, newEditingString newString: AutoreleasingUnsafeMutablePointer<NSString?>?, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool{
        return super.isPartialStringValid(partialString, newEditingString: newString, errorDescription: error)
    }

        // Compatibility method.  If a subclass overrides this and does not override the new method below, this will be called as before (the new method just calls this one by default).  The selection range will always be set to the end of the text with this method if replacement occurs.
        
    override func isPartialStringValid(_ partialStringPtr: AutoreleasingUnsafeMutablePointer<NSString>, proposedSelectedRange proposedSelRangePtr: NSRangePointer?, originalString origString: String, originalSelectedRange origSelRange: NSRange, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        return super.isPartialStringValid(partialStringPtr, proposedSelectedRange: proposedSelRangePtr, originalString: origString, originalSelectedRange: origSelRange, errorDescription: error)
    }
    
    
}
