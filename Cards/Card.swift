//
//  Card.swift
//  Cards
//
//  Created by Kaleb Page on 3/21/21.
//

import Foundation

struct ResponseObject: Codable {
    var cards: [Card]
}

struct Card: Codable {
    var image: String
    var value: String
    var suit: String
    var code: String
}
