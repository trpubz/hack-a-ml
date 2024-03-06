//
//  Player.swift
//  hack-a-ml
//
//  Created by Taylor Pubins on 2/16/24.
//

import Foundation

struct Player {
    var name: String!
    private let properties: [String: Any]

    init(kwargs: [String: Any]) {
        self.name = "\(kwargs["first_name"] as! String) \(kwargs["﻿last_name"] as! String)"
        self.properties = kwargs
    }

    // Accessor using subscript for dynamic field access
    subscript(key: String) -> Any? {
        return properties[key]
    }
}

enum PlayerError: Error {
    case invalidName
    case statsOutOfBounds
}
