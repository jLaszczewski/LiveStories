//
//  Message.swift
//  LiveStories
//
//  Created by Jakub Łaszczewski on 13.04.2018.
//  Copyright © 2018 Jakub Łaszczewski. All rights reserved.
//

import Foundation

enum TypeOfMessage {
    case leftVoice
    case rightVoice
    case comment
}

struct Message {
    let content: String
    let author: String?
    let type: TypeOfMessage
}
