//
//  CardBehavior.swift
//  playingCardv2
//
//  Created by Echo Wang on 8/16/19.
//  Copyright © 2019 Echo Wang Studio. All rights reserved.
//

import UIKit

// create own dynamic behavior
class CardBehavior: UIDynamicBehavior {
    
    // things have to be added as children in an init
    override init() {
        super.init()
        addChildBehavior(collisionBehavior)
        addChildBehavior(itemBehavior)
    }
    
    convenience init(in animator: UIDynamicAnimator) {
        self.init()
        animator.addBehavior(self)
    }
    
    //step1: create an animator
    //step2: create a behavior, init using a closure
    lazy var collisionBehavior: UICollisionBehavior = {
        let behavior = UICollisionBehavior()
        behavior.translatesReferenceBoundsIntoBoundary = true
        return behavior
    }()
    
    // works on item
    lazy var itemBehavior: UIDynamicItemBehavior = {
        let behavior = UIDynamicItemBehavior()
        behavior.allowsRotation = false
        // collision don't lose any energy
        // 1.1 would gain a little energy, item will go faster and faster
        behavior.elasticity = 1.0
        behavior.resistance = 0
        return behavior
    }()
    
    private func push(_ item: UIDynamicItem){
        let push = UIPushBehavior(items: [item], mode: .instantaneous)
        // push towards the center
        if let referenceBounds = dynamicAnimator?.referenceView?.bounds{
            let center = CGPoint(x: referenceBounds.midX, y: referenceBounds.midY)
            switch (item.center.x, item.center.y){
            case let (x,y) where x < center.x && y < center.y:
                push.angle = (CGFloat.pi/2).arc4random
            case let (x,y) where x > center.x && y < center.y:
                push.angle = CGFloat.pi - (CGFloat.pi/2).arc4random
            case let (x,y) where x < center.x && y > center.y:
                push.angle = -(CGFloat.pi/2).arc4random
            case let (x,y) where x > center.x && y > center.y:
                push.angle = CGFloat.pi + (CGFloat.pi/2).arc4random
            default:
                push.angle = (2*CGFloat.pi).arc4random
            }            
        }
        push.magnitude = CGFloat(1.0) + CGFloat(2.0).arc4random
        // avoid memory cycle
        push.action = { [unowned push, weak self] in
            self?.removeChildBehavior(push)
        }
        addChildBehavior(push)
    }
    
    // step3: add items to behavior
    func addItem(_ item: UIDynamicItem){
        collisionBehavior.addItem(item)
        itemBehavior.addItem(item)
        push(item)
    }
    
    func removeItem(_ item: UIDynamicItem){
        collisionBehavior.removeItem(item)
        itemBehavior.removeItem(item)
        //will remove push as soon as it add push 
    }
}
