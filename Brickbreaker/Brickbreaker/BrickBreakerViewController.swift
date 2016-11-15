    //
//  BrickBreakerViewController.swift
//  Brickbreaker
//
//  Created by Mohamed Hamza on 8/18/16.
//  Copyright © 2016 Mohamed Hamza. All rights reserved.
//

import UIKit

class BrickBreakerViewController: UIViewController, BrickBreakerViewDelegate {
    
//    func gameOverWithStatus(gameStatus: GameStatus, withScore score: Double) {
//        switch gameStatus {
//        case .Lose:
//            let alert = UIAlertController(title: "Game Over", message: "You lose. Your score is \(score)", preferredStyle: .ActionSheet)
//            alert.addAction(UIAlertAction(title: "New Game", style: .Default, handler: { (action) in
//                self.brickBreakerView.newGame()
//            }))
//            alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) in
//                alert.dismissViewControllerAnimated(true, completion: nil)
//            }))
//            presentViewController(alert, animated: true, completion: nil)
//        case .Win:
//            let alert = UIAlertController(title: "Game Over", message: "You win.", preferredStyle: .ActionSheet)
//            alert.addAction(UIAlertAction(title: "New Game", style: .Default, handler: { [unowned self] action in
//                self.brickBreakerView.newGame()
//            }))
//        }
//    }
    
    func gameOverWithStatus(gameStatus: GameStatus, withScore score: Double) {
        switch gameStatus {
        case .Lose:
            newGameView.hidden = false
        case .Win:
            newGameView.hidden = false
        }
    }
    
    @IBAction func newGame(sender: UIButton) {
        brickBreakerView.newGame()
        newGameView.hidden = true
    }

    @IBOutlet weak var newGameView: UIView!

    @IBOutlet weak var brickBreakerView: BrickBreakerView! {
        didSet {
            brickBreakerView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(BrickBreakerViewController.movePaddle(_:))))
            brickBreakerView.delegate = self
        }
    }
    
    func movePaddle(recognizer: UIPanGestureRecognizer) {
        if brickBreakerView.firstRun {
            brickBreakerView.beginGame(recognizer.translationInView(brickBreakerView).x)
            recognizer.setTranslation(CGPoint(x: 0, y: 0), inView: brickBreakerView)
            brickBreakerView.firstRun = false
        } else {
            if recognizer.state == .Ended || recognizer.state == .Changed || recognizer.state == .Began {
                brickBreakerView.movePaddle(recognizer.translationInView(brickBreakerView).x)
                recognizer.setTranslation(CGPoint(x: 0, y: 0), inView: brickBreakerView)
            }
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        brickBreakerView.animating = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        brickBreakerView.animating = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        brickBreakerView.newGame()
    }
    
}
