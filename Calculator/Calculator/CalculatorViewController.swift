//
//  ViewController.swift
//  Calculator
//
//  Created by Mohamed Hamza on 6/13/16.
//  Copyright © 2016 Mohamed Hamza. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {

    @IBAction private func touchDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if sender.currentTitle! == "." && display.text!.rangeOfString(".") != nil && userTyping { return }
        if userTyping {
            display.text! += digit
        } else {
            display.text! = digit
            userTyping = true
        }
    }
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet private weak var display: UILabel!
    
    private var userTyping = false
    
    private var brain = CalculatorBrain()
    
    @IBAction private func operation(sender: UIButton) {
        if userTyping{
            brain.setOperand(displayValue)
            userTyping = false
        }
        if let symbol = sender.currentTitle{
            brain.performOperation(symbol)
        }
        updateUI()
        
    }
    
    var savedProgram: CalculatorBrain.PropertyList?
    
    @IBAction func save() {
        savedProgram = brain.program
    }
    
    @IBAction func variable(sender: UIButton) {
        if sender.currentTitle == "M" {
            brain.setOperand("M")
        } else {
            brain.variableValues["M"] = displayValue
            brain.program = brain.program
            
        }
        updateUI()
        userTyping = false
    }
    
    private func updateUI() {
        displayValue = brain.result
        if brain.description != "" {
            if brain.isPartialResult {
                descriptionLabel.text = brain.description + "..."
            } else {
                descriptionLabel.text = brain.description + " ="
            }
        } else {
            descriptionLabel.text = ""
        }
        
    }
    
    @IBAction func restore() {
        if savedProgram != nil {
            brain.program = savedProgram!
            updateUI()
        }
    }
    
    private var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            let intVal = Int(newValue)
            if Double(intVal) == newValue {
                display.text = String(intVal)
            } else {
                display.text = String(newValue)
            }
        }
    }
    
    @IBAction func clear(sender: UIButton) {
        brain.clear()
        userTyping = false
        updateUI()
    }
    
    private var GraphView = GraphViewController()
    
    @IBAction func graph() {
        
    }
    
    func drawProgram (x: Double) -> Double {
        brain.variableValues["M"] = x
        brain.program = brain.program
        return brain.result
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showGraph" {
            if let gvc = segue.destinationViewController as? GraphViewController {
                gvc.drawingFunction = drawProgram
            }
        }
        
    }
}

