//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Edgar Salinas on 6/6/17.
//  Copyright © 2017 EHS LLC. All rights reserved.
//

import Foundation




struct CalculatorBrain {
    
    private var accumulator: Double?
    
    private var history: [String] = []
    
    private var lastOperation :LastOperation = .clear
    
    private let dot3: String = " ..."
    
    
    
    
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double,Double) -> Double)
        case equals
        case clear
    }
    
    private enum LastOperation {
        case digit
        case constant
        case unaryOperation
        case binaryOperation
        case equals
        case clear
    }
    
    private var operations: Dictionary<String,Operation> = [
        "π" : Operation.constant(Double.pi),
        "e" : Operation.constant(M_E),
        "√" : Operation.unaryOperation(sqrt),
        "cos": Operation.unaryOperation(cos),
        "sin": Operation.unaryOperation(sin),
        "tan": Operation.unaryOperation(tan),
        "±": Operation.unaryOperation({ -$0 }),
        "%" : Operation.unaryOperation({ $0 / 100.0 }),
        "x²" : Operation.unaryOperation({ $0 * $0 }),
        "x⁻¹" : Operation.unaryOperation({ 1 / $0 }),
        "×" : Operation.binaryOperation({ $0 * $1 }),
        "÷" : Operation.binaryOperation({ $0 / $1 }),
        "+" : Operation.binaryOperation({ $0 + $1 }),
        "−" : Operation.binaryOperation({ $0 - $1 }),
        "=": Operation.equals,
        "AC": Operation.clear
        ]
    
    
    mutating func performOperation(_ symbol: String){
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                history.append(symbol)
                accumulator = value
                lastOperation = .constant
                
            case .unaryOperation(let function):
                
                if accumulator != nil {
                   // wrapWithParens(symbol: symbol)
                    accumulator = function(accumulator!)
                    lastOperation = .unaryOperation
                }
                
            case .binaryOperation(let function):
                if lastOperation == .equals {
                    history.removeLast()
                }
                history.append(symbol)
                
                performPendingBinaryOperation()
                
                
                if accumulator != nil {
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    accumulator = nil
                }
                
                lastOperation = .binaryOperation
                
            case .equals:
                if lastOperation == .binaryOperation {
                    history.append(String(describing: accumulator))
                }
                history.append(symbol)
                performPendingBinaryOperation()
                lastOperation = .equals
            
            case .clear:
                clear()
                lastOperation = .clear
                
            }
        }
    }
   /*
    private mutating func wrapWithParens(symbol: String) {
        if lastOperation == .equals {
            
            history.insert(")", at: history.count - 1)
            history.insert(symbol, at: 0)
            history.insert("(", at: 1)
        } else {
            
            history.insert(symbol, at: history.count - 1)
            history.insert("(", at: history.count - 1)
            history.insert(")", at: history.count)
        }
    }
    */
    private mutating func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil{
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }
    }
    
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    private struct PendingBinaryOperation {
        let function: (Double,Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand,secondOperand)
        }
    }
    
    mutating func setOperand(_ operand: Double) {
        if lastOperation == .unaryOperation {
            history.removeAll()
        }
        
        accumulator = operand
        history.append(String(operand))
        lastOperation = .digit
        
    }
    
    var result: Double? {
        get {
            return accumulator
        }
    }
    
    var isPartialResult: Bool {
        get {
            return pendingBinaryOperation != nil
            
        }
    }
    
    var description : String {
        get {
            if pendingBinaryOperation != nil {
                
                return history.joined(separator: " ") + dot3
            }
            
            return history.joined(separator: " ")
            
        }
    }
    
     private mutating func clear() {
        accumulator = 0
        pendingBinaryOperation = nil
        history.removeAll()
        lastOperation = .clear
        
    }
   
}
