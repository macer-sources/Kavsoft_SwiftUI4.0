//
//  Message.swift
//  A_14_Advanced & Delay Transitions
//
//  Created by Kan Tao on 2023/6/20.
//

import Foundation

struct Message: Identifiable {
    var id = UUID().uuidString
    var message: String
    var isReply: Bool = false
    var emojiValue: String = ""
    var isEmojiAdded: Bool = false 
}
