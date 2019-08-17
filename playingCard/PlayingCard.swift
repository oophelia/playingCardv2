//
//  PlayingCard.swift
//  playingCard
//
//  Created by Echo Wang on 7/30/19.
//  Copyright © 2019 Echo Wang Studio. All rights reserved.
//

import Foundation

// CustomStringConvertible helps print nice in the console
struct PlayingCard: CustomStringConvertible{
    
    var description: String{
        return "\(suit)\(rank)"
    }
    
    var suit: Suit
    var rank: Rank
    
    // a lot of the raw values support backwards compatibility
    enum Suit: String, CustomStringConvertible{
        
        var description: String{
            return rawValue
        }
        
        case spades = "♠️"
        case hearts = "♥️"
        case diamonds = "♦️"
        case clubs = "♣️"
        
        static var all = [Suit.spades, .hearts, .diamonds, .clubs]
    }
    
    enum Rank: CustomStringConvertible{
        
        var description: String{
            switch self{
            case .ace : return "A"
            case .numeric(let pips): return String(pips)
            case .face(let kind): return kind
            }
        }
        
        case ace
        case face(String)
        case numeric(Int)
        
        var order: Int {
            switch  self {
            case .ace: return 1
            case .numeric(let pips): return pips
            case .face(let kind) where kind == "J": return 11
            case .face(let kind) where kind == "Q": return 12
            case .face(let kind) where kind == "K": return 13
            default : return 0
            }
        }
        
        static var all: [Rank]{
            var allRanks = [Rank.ace]
            for pips in 2...10{
                allRanks.append(Rank.numeric(pips))
            }
            // swift can infer the type of "Q" and "K"
            allRanks += [Rank.face("J"), face("Q"), face("K")]
            return allRanks
        }
    }
    
}
