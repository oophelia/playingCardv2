//
//  ViewController.swift
//  playingCard
//
//  Created by Echo Wang on 7/30/19.
//  Copyright © 2019 Echo Wang Studio. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var deck = PlayingCardDeck()
    
    @IBOutlet private var cardsView: [PlayingCardView]!
    
    lazy var animator = UIDynamicAnimator(referenceView: view)
    
    lazy var cardBehavior = CardBehavior(in: animator)
    
    // draw random cards at first
    override func viewDidLoad() {
        super.viewDidLoad()
        var cards = [PlayingCard]()
        for _ in 1...((cardsView.count+1)/2){
            let card = deck.draw()!
            cards += [card, card]
        }
        for cardView in cardsView{
            cardView.isFaceUp = false
            let card = cards.remove(at: cards.count.arc4random)
            cardView.rank = card.rank.order
            cardView.suit = card.suit.rawValue
            cardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(flipCards(_: ))))
            cardBehavior.addItem(cardView)
        }}
    
    // computed var
    // faceUpCardViews exclude two matching cards
    private var faceUpCardViews: [PlayingCardView]{
        return cardsView.filter{ $0.isFaceUp && !$0.isHidden && $0.transform != CGAffineTransform.identity.scaledBy(x: 3.0, y: 3.0) && $0.alpha == 1 }
    }
    
    private var faceUpCardViewsMatch: Bool{
        return faceUpCardViews.count == 2 && faceUpCardViews[0].rank == faceUpCardViews[1].rank &&
            faceUpCardViews[0].suit == faceUpCardViews[1].suit
    }
    
    var lastChosenCardView: PlayingCardView?
    
    @objc func flipCards(_ recognizer: UITapGestureRecognizer){
        switch recognizer.state{
        case .ended:
            // faceUpCardViews exclude two matching cards 
            if let chosenCardView = recognizer.view as? PlayingCardView, faceUpCardViews.count < 2{
                lastChosenCardView = chosenCardView
                // transition animation, flip chosen card over, stop animation
                cardBehavior.removeItem(chosenCardView)
                // make duration longer may help us find some overlapping problems
                UIView.transition(with: chosenCardView, duration: 0.5, options: [.transitionFlipFromLeft], animations: {chosenCardView.isFaceUp = !chosenCardView.isFaceUp},
                    // has an animation in the completion, check if two cards are matched
                    completion: { finished in
                        let cardsToAnimate = self.faceUpCardViews
                        // if two cards are matched, scale big and then small, into disappear
                        if self.faceUpCardViewsMatch {
                            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.6, delay: 0, options: [], animations: { cardsToAnimate.forEach{
                                $0.transform = CGAffineTransform.identity.scaledBy(x: 3.0, y: 3.0)
                                }}, completion: { position in
                                    // give longer time, because it changes from 3.0x to 0.1x
                                    UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.75, delay: 0, options: [], animations: { cardsToAnimate.forEach{
                                        $0.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
                                        $0.alpha = 0
                                        }}, completion:{ position in
                                            cardsToAnimate.forEach{
                                            // clean up, make them to originals but hidden
                                            $0.isHidden = true
                                            $0.alpha = 1
                                            $0.transform = .identity
                                            }
                                    })}
                            )}
                        // if two cards are not matched, make them facedown
                        else if cardsToAnimate.count == 2 {
                            // only let lastChosenCardView control this animation
                            if chosenCardView == self.lastChosenCardView {
                                cardsToAnimate.forEach { cardView in
                                    UIView.transition(with: cardView, duration: 0.5, options: [.transitionFlipFromLeft], animations: {cardView.isFaceUp = false}, completion: { finished in
                                        // self won't make memory cycle since it's in animation closure
                                        self.cardBehavior.addItem(cardView)
                                    })
                                }
                            }
                        } else {
                            // pick one card up and then down, add behavior back
                            if !chosenCardView.isFaceUp{
                                self.cardBehavior.addItem(chosenCardView)
                            }
                        }
                })
            }
        default:
            break
        }
    }
    
}

extension Float{
    var arc4random: Float{
        if self > 0 {
            return Float.random(in: 0...self)
        } else if self < 0 {
            return Float.random(in: -self...0)
        } else {
            return 0
        }
    }
}

extension CGFloat{
    var arc4random: CGFloat{
        return CGFloat(Float(self).arc4random)
    }
}
