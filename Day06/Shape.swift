//
//  Shape.swift
//  Day06
//
//  Created by Anastasiia VEREMIICHYK on 09.04.2019.
//  Copyright © 2019 Anastasiia VEREMIICHYK. All rights reserved.
//

import UIKit

class Shape: UIView {
    var isSquare = true
    var size: CGFloat = 100
    
    init(location: CGPoint) {
        super.init(frame: CGRect(x: location.x, y: location.y, width: size, height: size))
        isSquare = arc4random_uniform(2) == 0
        if !isSquare {
            self.layer.cornerRadius = size / 2
            isSquare = false
        }
        self.backgroundColor = UIColor(red: .random, green: .random, blue: .random, alpha: 1.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var collisionBoundsType: UIDynamicItemCollisionBoundsType {
        return (self.isSquare == true) ? .rectangle : .ellipse
    }
}
