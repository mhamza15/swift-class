//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Mohamed Hamza on 6/13/16.
//  Copyright © 2016 Mohamed Hamza. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    private var internalProgram = [AnyObject]()
    
    private var accumulator = 0.0
    
    private var accumulatorDescription: Description?
    
    func setOperand(operand: Double) {
        accumulatorDescription = Description.Constant(String(operand))
        accumulator = operand
        internalProgram.append(operand)
    }
    
    func setOperand(variableName: String) {
        accumulator = variableValues[variableName] ?? 0.0
        accumulatorDescription = Description.Constant(variableName)
        internalProgram.append(variableName)
    }
    
    var variableValues = [String: Double]()
   
    private var operations: Dictionary<String,Operation> = [
        "π" : Operation.Constant(M_PI),
        "e" : Operation.Constant(M_E),
        "±" : Operation.UnaryOperation({ -$0 }),
        "√" : Operation.UnaryOperation(sqrt),
        "sin" : Operation.UnaryOperation(sin),
        "cos" : Operation.UnaryOperation(cos),
        "tan" : Operation.UnaryOperation(tan),
        "log" : Operation.UnaryOperation(log10),
        "ln" : Operation.UnaryOperation(log),
        "%" : Operation.UnaryOperation({ $0 / 100 }),
        "✕" : Operation.BinaryOperation({ $0 * $1 }),
        "+" : Operation.BinaryOperation({ $0 + $1 }),
        "÷" : Operation.BinaryOperation({ $0 / $1 }),
        "−" : Operation.BinaryOperation({ $0 - $1 }),
        "=" : Operation.Equals
    ]
    
    private enum Operation {
        case Constant(Double)
        case UnaryOperation(Double -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }
    
    private indirect enum Description {
        case Constant(String)
        case UnaryOperation(String, Description)
        case BinaryOperation(String, Description, Description)
        
        var toString: String {
            get {
                switch self {
                case .Constant(let value):
                    return value
                case .UnaryOperation(let operation, let operand):
                    return "\(operation)(\(operand.toString))"
                case .BinaryOperation(let operation, let operand1, let operand2):
                    return "\(operand1.toString)\(operation)\(operand2.toString)"
                }
            }
        }
    }
    
    func performOperation(symbol: String) {
        internalProgram.append(symbol)
        if let operation = operations[symbol]{
            switch operation {
            case .Constant(let value):
                accumulatorDescription = Description.Constant(symbol)
                accumulator = value
            case .UnaryOperation(let function):
                if accumulatorDescription == nil {
                    accumulatorDescription = Description.Constant(String(accumulator))
                }
                accumulatorDescription = Description.UnaryOperation(symbol, accumulatorDescription!)
                accumulator = function(accumulator)
            case .BinaryOperation(let function):
                if accumulatorDescription == nil {
                    accumulatorDescription = Description.Constant(String(accumulator))
                }
                executeBinaryOperation()
                pending = PendingInfo(binaryFunction: function, firstOperand: accumulator, firstDescription: accumulatorDescription!, symbol: symbol)
                accumulatorDescription = nil
            case .Equals:
                executeBinaryOperation()
            }
        }
    }
    
    typealias PropertyList = AnyObject
    
    var program: PropertyList {
        get {
            return internalProgram
        }
        set {
            clear()
            if let arrayOfOps = newValue as? [AnyObject] {
                for op in arrayOfOps {
                    if let operand = op as? Double {
                        setOperand(operand)
                    } else if let operationOrVar = op as? String {
                        if operations[operationOrVar] != nil {
                            performOperation(operationOrVar)
                        } else {
                            setOperand(operationOrVar)
                        }
                        
                    }
                }
            }
        }
    }

    var description: String {
        get {
            var str = ""
            if pending != nil {
                str += pending!.firstDescription.toString + pending!.symbol
            }
            if accumulatorDescription != nil {
                str += accumulatorDescription!.toString
            }
            return str
        }
    }
    
    var isPartialResult: Bool {
        get {
            return pending != nil
        }
    }
    
    private func executeBinaryOperation(){
        if pending != nil {
            if accumulatorDescription == nil {
                accumulatorDescription = Description.Constant(String(accumulator))
            }
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            
            accumulatorDescription = Description.BinaryOperation(pending!.symbol, pending!.firstDescription, accumulatorDescription!)
            pending = nil
        }
    }
    
    private var pending: PendingInfo?
    
    private struct PendingInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
        var firstDescription: Description
        var symbol: String
    }
    
    var result: Double {
        get {
            return accumulator
        }
    }
    
    func clear() {
        accumulator = 0.0
        pending = nil
        accumulatorDescription = nil
        internalProgram.removeAll()
    }
    
}