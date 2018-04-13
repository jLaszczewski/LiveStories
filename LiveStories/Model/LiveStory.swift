//
//  LiveStory.swift
//  LiveStories
//
//  Created by Jakub Łaszczewski on 11.04.2018.
//  Copyright © 2018 Jakub Łaszczewski. All rights reserved.
//

import Foundation

struct LiveStory: Codable {
    var month: String
    var num: Int
    var link: String
    var year: String
    var news: String
    var safe_title: String
    var transcript: String
    var alt: String
    var img: String
    var title: String
    var day: String
    
    static func endpointFor(_ num: Int) -> String {
        return "https://xkcd.com/\(num)/info.0.json"
    }
}
