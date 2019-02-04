//
//  Deck+Card.swift
//  DeckOfOneCardiOS24
//
//  Created by Cameron Milliken on 2/4/19.
//  Copyright © 2019 Cameron Milliken. All rights reserved.
//

import Foundation

struct TopLevelDictionary: Codable {
    let cards: [Card]
}

struct Card: Codable {
    let value: String
    let suit: String
    let image: String
}
