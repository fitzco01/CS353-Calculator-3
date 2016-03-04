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
    
    //fix toInfix and postfixtoinfix
    //toInfix doesn't work (pops from stack so that it won't print?
    
    typealias PropertyList = AnyObject
    
    var program: PropertyList { //guaranteed to be a PropertyList
        get {
            return opStack.map { $0.description }
        }
        set {
            if let opSymbols = newValue as? Array<String> {
                var newOpStack = [Op]()
                for opSymbol in opSymbols {
                    if let op = knownOps[opSymbol] {
                        newOpStack.append(op)
                    } else if let operand = NSNumberFormatter().numberFromString(opSymbol)?.doubleValue {
                        newOpStack.append(.Operand(operand))
                    }
                }
                opStack = newOpStack
            }
        }
    }
    
    var newStack: [Op] = []
    
//    func toInfix() -> String{
//            let temp = opStack.popLast()
//        if temp != nil {
//            newStack.append(temp!)
//            return "\(temp!)"
//        } else {
//            return "TEST"
//        }
//    }
//    
//    func postfixtoinfix(remainingOps: String) -> String{
//        if newStack.count > 4 {
//            print("(" + toInfix() + toInfix() + toInfix() + ")")
//        }
//        return ""
//    }
    
    func clear(clearType: String, displayStr: String) -> String {
        switch clearType {
            case "C":
            opStack = [Op]()
            cleared = true
            return "0"
        default:
            return "Clear Button Error"
        }
    }
    
    var answer = ""
    var tempoperands = [String]()
    var cleared = false
    
    func history() -> String {
        var tempOpStack = [Op]()
        if cleared == false {
            tempOpStack = opStack
        } else if cleared == true {
            answer = ""
            cleared = false
        }
        
        while !tempOpStack.isEmpty {
            let temp = tempOpStack.removeFirst()
            switch temp {
            case .UnaryOperation:
                answer = "\(temp)" + "(" + tempoperands.removeLast() + ")"
            case .BinaryOperation:
                let old = tempoperands.removeLast()
                answer = "(" + tempoperands.removeLast() + "\(temp)" + old + ")"
            case .Operand:
                tempoperands.append("\(temp)")
            }
        }
        return "= " + answer
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
    
    var infixstring = String()
    
    var memorydict = [String: Op]()
    
    func memory(whichmem: String) -> Double? {
        if whichmem == "M+" { //adding double to memory
             memorydict["M"] = opStack.popLast()
        } else if whichmem == "M" { //using the memory
            if memorydict["M"] != nil {
           opStack.append(memorydict["M"]!)
            } else {
            }
        }
        return evaluate()
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double? {
        
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
}