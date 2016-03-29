//
//  CalculatorViewController.swift
//  Calculator
//
//  Created by Connor Fitzpatrick on 2/9/16.
//  Copyright © 2016 Connor Fitzpatrick. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {

    @IBOutlet weak var display: UILabel!

    var brain = CalculatorBrain()
    //var graph = GraphViewController()
    
    @IBOutlet weak var history: UILabel!
    
    var userIsInTheMiddleOfTypingANumber = false
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if digit == "." {
            if display.text!.containsString(".") == false {
                display.text = display.text! + digit
            }
        } else if digit == "⌫" {
            if displayValue == 0  || display.text!.characters.count == 1 {
                displayValue = 0
            }
            else {
                display.text = String(display.text!.characters.dropLast())
            }
        } else if digit == "π" {
           displayValue = brain.pi(userIsInTheMiddleOfTypingANumber, displayStr: display.text!)
           userIsInTheMiddleOfTypingANumber = false
        } else if digit == "M" {
            if userIsInTheMiddleOfTypingANumber {
            } else {
            brain.memory("M")
            userIsInTheMiddleOfTypingANumber = false
            }
        } else if digit == "M+" {
            brain.memory("M+")
            userIsInTheMiddleOfTypingANumber = false
        } else if digit == "📉" {
            
            
            //write the graph class
            
            
            //graph()
            userIsInTheMiddleOfTypingANumber = false
        } else if userIsInTheMiddleOfTypingANumber {
            display.text = display.text! + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
     // testing  brain.postfixtoinfix(brain.toInfix())
    }
    
    @IBAction func clearButton(sender: UIButton) {
        display.text! = brain.clear(sender.currentTitle!, displayStr: display.text!)
        userIsInTheMiddleOfTypingANumber = false
        history.text = "History"
    }
    
    @IBAction func operate(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        if let operation = sender.currentTitle {
           if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = 0 //make this nil (change other stuff to optionals)
            }
        }
    }
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        if let result = brain.pushOperand(displayValue) {
            displayValue = result
            history.text = brain.history()
        } else {
            displayValue = 0 //make this nil (change other stuff to optionals)
        }
    }
    
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }
}
