//
//  GraphViewController.swift
//  Calculator
//
//  Created by Mohamed Hamza on 7/11/16.
//  Copyright © 2016 Mohamed Hamza. All rights reserved.
//

import UIKit



class GraphViewController: UIViewController, GraphViewDelegate {
    
    @IBOutlet weak var graph: GraphView!{
        didSet{
            if drawingFunction != nil {
                graph.delegate = self
            }
        }
    }
    
    var drawingFunction: ((Double) -> Double)? {
        didSet {
            graph?.delegate = self
        }
    }
    
    func xToY(x: Double) -> Double {
        return drawingFunction!(x)
    }
    
    @IBAction func zoom(sender: UIPinchGestureRecognizer) {
        
        switch sender.state {
        case.Began: fallthrough
        case.Ended: fallthrough
        case .Changed:
            graph.scale *= sender.scale
            sender.scale = 1.0
        default: break
        }
        
    }

    @IBAction func moveOrigin(sender: UITapGestureRecognizer) {
        
        if sender.state == .Ended {
            graph.originPoint = sender.locationInView(graph)
        }
        
    }
    
    @IBAction func move(sender: UIPanGestureRecognizer) {
        
        switch sender.state {
        case .Ended: fallthrough
        case .Changed:
            let translation = sender.translationInView(graph)
            graph.originPoint = CGPoint(x: translation.x + graph.origin.x, y: translation.y + graph.origin.y)
            sender.setTranslation(CGPointZero, inView: graph)
        default: break
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
