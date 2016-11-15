//
//  BrickBreakerView.swift
//  Brickbreaker
//
//  Created by Mohamed Hamza on 8/18/16.
//  Copyright © 2016 Mohamed Hamza. All rights reserved.
//

import UIKit

enum GameStatus {
    case Win
    case Lose
}

protocol BrickBreakerViewDelegate {
    
    func gameOverWithStatus(gameStatus: GameStatus, withScore: Double)
    
}

@IBDesignable class BrickBreakerView: UIView, UICollisionBehaviorDelegate {
    
    var delegate: BrickBreakerViewDelegate?
    
    var viewController = BrickBreakerViewController()

    var firstRun = true
    
    private let gravity = UIGravityBehavior()
    
    private var gravityMagnitude: CGFloat = 0.0 {
        didSet {
            gravity.magnitude = gravityMagnitude
        }
    }
    
    private let collider: UICollisionBehavior = {
        let collider = UICollisionBehavior()
        return collider
    }()
    
    private let itemBehavior: UIDynamicItemBehavior = {
       let itemBehavior = UIDynamicItemBehavior()
        itemBehavior.elasticity = 1.0
        itemBehavior.resistance = 0.0
        itemBehavior.friction = 0.0
        itemBehavior.charge = 0.0
        itemBehavior.allowsRotation = true
        return itemBehavior
    }()
    
    private lazy var animator: UIDynamicAnimator = UIDynamicAnimator(referenceView: self)
    
    private var _scoreBalls = [UIView]()
    
    private var scoreBalls : [UIView] {
        get {
            if _scoreBalls.isEmpty {
                var startingX = CGFloat(7)

                for _ in 0..<lives {
                    let scoreBall = UIView(frame: CGRect(x: startingX, y: 30, width: 16, height: 16))
                    _scoreBalls.append(scoreBall)
                    scoreBall.backgroundColor = ballColor
                    scoreBall.layer.cornerRadius = scoreBall.bounds.width / 2
                    scoreBall.clipsToBounds = true
                    self.addSubview(scoreBall)
                    startingX += 22
                }
            }
            return _scoreBalls
        } set {
            var startingX = CGFloat(7)
            
            for _ in 0..<lives {
                let scoreBall = UIView(frame: CGRect(x: startingX, y: 30, width: 16, height: 16))
                _scoreBalls.append(scoreBall)
                scoreBall.backgroundColor = ballColor
                scoreBall.layer.cornerRadius = scoreBall.bounds.width / 2
                scoreBall.clipsToBounds = true
                self.addSubview(scoreBall)
                startingX += 22
            }
        }
    }
    
    func setInitialViews() {
        var y = CGFloat(80)
        for row in 0..<rows {
            var x = CGFloat(8)
            for col in 0..<bricksPerRow {
                bricks[row][col].frame = CGRect(origin: CGPoint(x: x, y: y), size: brickSize)
                x += brickSize.width + 5
            }
            y += brickSize.height + 5
        }
        scoreLabel.frame = CGRect(x: self.bounds.midX - 25, y: 25, width: 50, height: 25)
        
        paddle.frame = CGRect(origin: CGPoint(x: bounds.midX - 30, y: bounds.maxY - 30), size: CGSize(width: 60, height: 12))
        ball.frame = CGRect(origin: CGPoint(x: bounds.midX, y: bounds.midY), size: CGSize(width: 20, height: 20))
        ball.center = CGPoint(x: bounds.midX, y: bounds.midY)
        _ = scoreBalls // just to ignite lazy init
    }
    
    func setPhysics() {
        
        resetPhysics()

        ball.layer.cornerRadius = ball.frame.width / 2
        ball.clipsToBounds = true
        
        collider.removeAllBoundaries()
        
        collider.addBoundaryWithIdentifier("leftSide", fromPoint: CGPointZero, toPoint: CGPoint(x: 0, y: bounds.maxY))
        collider.addBoundaryWithIdentifier("top", fromPoint: CGPointZero, toPoint: CGPoint(x: bounds.maxX, y: 0))
        collider.addBoundaryWithIdentifier("rightSide", fromPoint: CGPoint(x: bounds.maxX, y: 0), toPoint: CGPoint(x: bounds.maxX, y: bounds.maxY))
        collider.addBoundaryWithIdentifier("bottom", fromPoint: CGPoint(x: 0, y: bounds.maxY + 40), toPoint: CGPoint(x: bounds.maxX, y: bounds.maxY + 40))

        itemBehavior.addItem(ball)
        collider.addItem(ball)
        
        for row in 0..<rows {
            for col in 0..<bricksPerRow {
                collider.addBoundaryWithIdentifier(row * bricksPerRow + col, forPath: UIBezierPath(rect: bricks[row][col].frame))
            }
        }
        
        collider.addBoundaryWithIdentifier("Paddle", forPath: UIBezierPath(ovalInRect: paddle.frame))
    }
    
    var animating: Bool = false {
        didSet {
            if animating {
                animator.addBehavior(collider)
                collider.collisionDelegate = self
                animator.addBehavior(gravity)
                animator.addBehavior(itemBehavior)
            } else {
                animator.removeBehavior(collider)
                animator.removeBehavior(gravity)
                animator.removeBehavior(itemBehavior)
            }
        }
    }

    private var bricksPerRow: Int {
        get {
            return valueForSetting("bricksPerRow")
        }
    }
    
    private var rows: Int {
        get {
            return valueForSetting("rows")
        }
    }
    
    private let brickHeight = 20
    
    private var totalLives: Int {
        get {
            return valueForSetting("lives")
        }
    }
    
    private lazy var lives: Int = { self.totalLives }()
    
    private lazy var bricksLeft: Int = { return self.bricksPerRow * self.rows }()
    
    private var score: Int {
        get {
            return self.bricksPerRow * self.rows - self.bricksLeft
        }
    }
    
    private lazy var paddle: UIView = {
        
        let paddle = UIView()
        
        paddle.backgroundColor = UIColor.blackColor()
        paddle.layer.cornerRadius = 5
        paddle.layer.masksToBounds = true
        
        self.addSubview(paddle)
        return paddle
    }()
    
    private var ballColors = [UIColor.darkGrayColor(), UIColor.orangeColor(), UIColor.purpleColor()]
    
    private lazy var ballColor: UIColor = { self.ballColors[self.valueForSetting("ballColor")] }()
    
    lazy var ball: UIView = {
        let ball = ViewWithCircularCollision()
        
        ball.backgroundColor = self.ballColor
        self.addSubview(ball)
        
        return ball
    }()
    
    private var brickSize: CGSize {
        let size = (bounds.size.width - 35) / CGFloat(bricksPerRow)
        return CGSize(width: size, height: CGFloat(brickHeight))
    }
    
    private var colors = [UIColor.redColor(), UIColor.blueColor()]
    
    private lazy var bricks: [[UIView]] = {

        var bricks: [[UIView]] = []
        
        for row in 0..<self.rows {
            bricks.append([])
            for col in 0..<self.bricksPerRow {
                let brick = UIView()
                brick.backgroundColor = self.colors[row % 2]
                brick.layer.cornerRadius = 5
                brick.layer.masksToBounds = true
                self.addSubview(brick)
                bricks[row].append(brick)
            }
        }
        return bricks
    }()
    
    func movePaddle(translationX: CGFloat) {
        paddle.center.x += translationX
        collider.removeBoundaryWithIdentifier("Paddle")
        collider.addBoundaryWithIdentifier("Paddle", forPath: UIBezierPath(ovalInRect: paddle.frame))
    }
    
    func beginGame(translationX: CGFloat) {
        itemBehavior.addLinearVelocity(CGPoint(x: 0, y: 450), forItem: ball)
        paddle.center.x += translationX
        collider.removeBoundaryWithIdentifier("Paddle")
        collider.addBoundaryWithIdentifier("Paddle", forPath: UIBezierPath(ovalInRect: paddle.frame))
    }
    
    func collisionBehavior(behavior: UICollisionBehavior, endedContactForItem item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?) {
        if let id = identifier as? Int {
            let row = id / bricksPerRow
            let col = id % bricksPerRow
            let brick = bricks[row][col]
            UIView.animateWithDuration(0.3, animations: { brick.alpha = 0 }, completion: { [unowned self] completed in
                if completed {
                    brick.hidden = true
                    brick.alpha = 0
                    self.bricksLeft -= 1
                    if self.bricksLeft <= 0 {
                        self.delegate?.gameOverWithStatus(.Win, withScore: Double(self.bricksPerRow * self.rows))
                    }
                    self.scoreLabel.text = "Score: \(self.score)"
                    self.collider.removeBoundaryWithIdentifier(id)
                }
            })
            scoreLabel.text = "Score: \(self.score)"
        } else if let id = identifier as? String {
            if id == "bottom" {
                lives -= 1
                let scoreBall = scoreBalls[lives]
                UIView.animateWithDuration(0.3, animations: { scoreBall.alpha = 0 }, completion: { completed in
                    if completed {
                        scoreBall.hidden = true
                        scoreBall.alpha = 0
                    }})
                if lives == 0 {
                    delegate?.gameOverWithStatus(.Lose, withScore: Double(bricksPerRow * rows - bricksLeft))
                    lives = 3
                }
                resetBall()
            }
        }
    }
    
    private func resetBall() {
        print("called restball")
        itemBehavior.removeItem(ball)
        collider.removeItem(ball)
        ball.alpha = 0
//        ball.center = CGPoint(x: -50, y: bounds.midY)
        if lives == 0 {
            return
        }
        ball.center = scoreBalls[lives - 1].center
        ball.backgroundColor = ballColor
        UIView.animateWithDuration(
            0.5,
            animations: { [unowned self] in
                self.ball.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
                self.ball.alpha = 1.0
                print("alpha1 = \(self.ball.alpha)")
            },
            completion: { [unowned self] completed in
                if completed {
                    self.itemBehavior.addItem(self.ball)
                    self.collider.addItem(self.ball)
                    self.firstRun = true
                    print("alpha = \(self.ball.alpha)")
                }
        })
    }
    
    
    
    private func valueForSetting(setting: String) -> Int {
        let defaultValues = ["lives" : 3,
                             "bricksPerRow" : 5,
                             "rows" : 4,
                             "ballColor" : 0]
        return NSUserDefaults.standardUserDefaults().dictionaryForKey("brickBreakerSettings")?[setting] as? Int ?? defaultValues[setting]!
    }
    
    private func newBricks() {
        for brickRow in bricks {
            for brick in brickRow {
                brick.removeFromSuperview()
            }
        }
        
        bricks = []
        
        for row in 0..<rows {
            bricks.append([])
            
            for _ in 0..<bricksPerRow {
                let brick = UIView()
                brick.backgroundColor = colors[row % 2]
                brick.layer.cornerRadius = 5
                brick.layer.masksToBounds = true
                addSubview(brick)
                bricks[row].append(brick)
            }
        }
        
    }
    
    func newGame() {
        
        resetPhysics()
        
        lives = (valueForSetting("lives"))
        ballColor = ballColors[(valueForSetting("ballColor"))]
        bricksLeft = bricksPerRow * rows
        scoreBalls = [UIView]()
        
        newBricks()
        
        setInitialViews()
        
        setPhysics()
        firstRun = true
        print("ball = \(ball.center) alpha = \(ball.alpha)")
    }
    
    private func resetPhysics() {
        
        itemBehavior.removeItem(ball)
        collider.removeItem(ball)
        
        collider.removeAllBoundaries()

    }
    
    private lazy var scoreLabel: UILabel = { [unowned self] in
        let x = UILabel()
        x.hidden = false
        x.textAlignment = NSTextAlignment.Center
        x.adjustsFontSizeToFitWidth = true
        x.textColor = UIColor.whiteColor()
        x.text = "Score: \(self.score)"
        self.addSubview(x)
        return x
    }()

    
}
