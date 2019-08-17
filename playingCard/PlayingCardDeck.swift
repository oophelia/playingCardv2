//
//  PlayingCardDeck.swift
//  playingCard
//
//  Created by Echo Wang on 7/31/19.
//  Copyright © 2019 Echo Wang Studio. All rights reserved.
//

import Foundation

struct PlayingCardDeck{
    
    private(set) var cards = [PlayingCard]()
    
    init(){
        // Suit is in struct of PlayingCard, use nesting "PlayingCard.Suit"
        // PlayingCard.Suit.all is an array
        for suit in PlayingCard.Suit.all {
            for rank in PlayingCard.Rank.all{
                cards.append(PlayingCard(suit: suit, rank: rank))
            }
        }
    }
    
    mutating func draw() -> PlayingCard? {
        if cards.count > 0 {
            return cards.remove(at: cards.count.arc4random)
        } else {
            return nil
        }
    }
    
}

extension Int{
    var arc4random:Int{
        if self > 0 {
            // self is int
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}
