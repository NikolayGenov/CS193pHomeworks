//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Nikolay Genov on 5/8/17.
//  Copyright © 2017 Nikolay Genov. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    
    private var accumulator: Double?
    
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double,Double) -> Double)
        case equals
        case clear
    }
    
    private var operatios: Dictionary<String, Operation> = [
        "π": Operation.constant(Double.pi),
        "e": Operation.constant(M_E),
        "√": Operation.unaryOperation(sqrt),
        "﹪": Operation.unaryOperation({ $0 / 100.0}),
        "1/x": Operation.unaryOperation({ 1.0 / $0 }),
        "x²": Operation.unaryOperation({ pow($0, 2)}),
        "±": Operation.unaryOperation({ -$0 }),
        "+": Operation.binaryOperation({ $0 + $1 }),
        "−": Operation.binaryOperation({ $0 - $1 }),
        "×": Operation.binaryOperation({ $0 * $1 }),
        "÷": Operation.binaryOperation({ $0 / $1 }),
        "=": Operation.equals,
        "C": Operation.clear
    ]
    
    mutating func performOperation(_ symbol: String) {
        if let operation = operatios[symbol] {
            switch operation {
            case .constant(let value):
                accumulator = value
                constantSymbol = symbol
            case .unaryOperation(let function):
                if accumulator != nil {
                    setLastBuffer()
                    lastBuffer = "\(symbol)(\(lastBuffer))"
                    accumulator = function(accumulator!)
                }
            case .binaryOperation(let function):
                if accumulator != nil {
                    setLastBuffer()
                    textAccumulator += "\(lastBuffer) \(symbol) "
                    lastBuffer = ""
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    accumulator = nil
                }
            case .equals:
                performPendingBinaryOperation()
            case .clear:
                pendingBinaryOperation = nil
                textAccumulator = ""
                lastBuffer = ""
                constantSymbol = ""
                accumulator = 0
            }
        }
    }
    
    mutating private func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
            setLastBuffer()
            textAccumulator += lastBuffer
            lastBuffer = textAccumulator
            textAccumulator = ""
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }
    }
    
    var resultIsPending: Bool {
        get {
            return pendingBinaryOperation != nil
        }
    }
    
    var description: String  {
        get {
            return textAccumulator + lastBuffer
        }
    }
    
    private var textAccumulator: String = ""
    private var lastBuffer: String = ""
    private var constantSymbol: String = ""

    mutating private func setLastBuffer() {
        if lastBuffer.isEmpty {
            if constantSymbol.isEmpty{
                lastBuffer = accumulator!.clean
            } else {
                lastBuffer =  constantSymbol
                constantSymbol = ""
            }
        }
    }
    
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    mutating func setOperand(_ operand: Double) {
        if result != nil {
            textAccumulator = ""
            lastBuffer = ""
        }
        accumulator = operand
        
    }
    
    var result: Double? {
        get {
            return accumulator
        }
    }
}

