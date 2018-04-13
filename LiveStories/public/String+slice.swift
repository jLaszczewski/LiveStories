//
//  String+slice.swift
//  LiveStories
//
//  Created by Jakub Łaszczewski on 13.04.2018.
//  Copyright © 2018 Jakub Łaszczewski. All rights reserved.
//

import Foundation

extension String {
//    func slice(from initialString: String, to endString: String) -> Substring? {
//        return (range(of: initialString)?.upperBound).flatMap { substringFrom in
//            (range(of: endString, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
//                self[substringFrom..<substringTo]
//            }
//        }
//    }
    func slice(from initialString: String, to endString: String) -> String? {
        if let substringFrom = range(of: initialString)?.upperBound, let substringTo = range(of: endString)?.lowerBound {
            return String(self[substringFrom..<substringTo])
        }
        return nil
    }
    
    func slice(to endString: String) -> String? {
        if let substringTo = range(of: endString)?.lowerBound {
            return String(self[..<substringTo])
        }
        return nil
    }
    
    func slice(from initialString: String) -> String? {
        if let substringFrom = range(of: initialString)?.upperBound {
            return String(self[substringFrom...])
        }
        return nil
    }
    
}
