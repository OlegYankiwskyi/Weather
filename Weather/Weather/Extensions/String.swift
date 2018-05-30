//
//  String.swift
//  Weather
//
//  Created by Oleg Yankiwskyi on 5/18/18.
//  Copyright © 2018 Oleg Yankiwskyi. All rights reserved.
//

import Foundation

extension String {
    
    func substringToIndex(_ index: Int) -> String {
        let index = self.index(self.startIndex, offsetBy: index)
        let parcedDate = self[..<index]
        return String(parcedDate)
    }
    
    var length: Int {
        return self.count
    }
    
    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }
    
    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }
    
    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
}
