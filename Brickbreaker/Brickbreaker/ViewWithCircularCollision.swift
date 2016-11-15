//
//  ViewWithCircularCollision.swift
//  Brickbreaker
//
//  Created by Mohamed Hamza on 8/19/16.
//  Copyright © 2016 Mohamed Hamza. All rights reserved.
//

import UIKit

class ViewWithCircularCollision: UIView {

    override var collisionBoundsType: UIDynamicItemCollisionBoundsType {
        return .Ellipse
    }

}
