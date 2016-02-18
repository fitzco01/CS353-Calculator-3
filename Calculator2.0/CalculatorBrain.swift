//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Connor Fitzpatrick on 2/15/16.
//  Copyright © 2016 Connor Fitzpatrick. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    enum Op: CustomStringConvertible {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        
        var description: String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                }
            }
        }
    }
    
    private var opStack = [Op]()
    
    private var knownOps = [String:Op]()
    
    init() {
        func learnOp(op: Op) {
            knownOps[op.description] = op
        }
        learnOp(Op.BinaryOperation("×", *))
        learnOp(Op.BinaryOperation("+", +))
        learnOp(Op.BinaryOperation("÷", { $1 / $0 }))
        learnOp(Op.BinaryOperation("−", { $1 - $0 }))
        
        learnOp(Op.UnaryOperation("√", sqrt))
        learnOp(Op.UnaryOperation("+/-", { $0 * -1 }))
        learnOp(Op.UnaryOperation("sin", { sin($0) }))
        learnOp(Op.UnaryOperation("cos", { cos($0) }))
    }
    
    func clear(clearType: String, displayStr: String) -> String {
        switch clearType {
            case "C":
            opStack = [Op]()
            return "0"
        default:
            return "Clear Button Error"
        }
    }
    
    func history() -> Array<Op> {
        return opStack
    }
    
    func pi(piType: Bool, displayStr: String) -> Double {
        switch piType {
        case true:
            pushOperand(Double(displayStr)!)
            pushOperand(M_PI)
            return M_PI
        default:
            pushOperand(M_PI)
            return M_PI
        }
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
        
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            }
        }
        
        return (nil, ops)
    }
    
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack)
        print("\(opStack) = \(result) with \(remainder) left over")
        return result
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    
//    //Clear and delete functions go here?
//    func pi1(display: Double) {
//        opStack.append(M_PI)
//        opStack.append(display)
//    }
//    
//    func pi2() {
//        opStack.append(M_PI)
//    }
//    
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
}