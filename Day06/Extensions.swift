//
//  Extensions.swift
//  Day06
//
//  Created by Anastasiia VEREMIICHYK on 09.04.2019.
//  Copyright © 2019 Anastasiia VEREMIICHYK. All rights reserved.
//

import UIKit

extension CGFloat {
    static var random: CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}
