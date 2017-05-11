//
//  ViewController.swift
//  Calculator
//
//  Created by Nikolay Genov on 5/5/17.
//  Copyright © 2017 Nikolay Genov. All rights reserved.
//

import UIKit
import AVFoundation



class ViewController: UIViewController {
    
    
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var calculationDescription: UILabel!
    
    var userIsInTheMiddleOfTyping = false
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay  = display.text!
            display.text = textCurrentlyInDisplay + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTyping = true
        }
    }
    
    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = newValue.clean
        }
    }
    
    var displayDescription: String {
        get {
            return calculationDescription.text!
        }
        set {
            calculationDescription.text = newValue
        }
    }
    
    private var brain = CalculatorBrain()
    
    @IBAction func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        
        displayDescription = brain.description
        
        if !displayDescription.isEmpty {
            displayDescription += brain.resultIsPending ? "..." : "="
        } else {
            displayDescription = " "
        }
        if let result = brain.result {
            displayValue = result
        }
    }
    
}


