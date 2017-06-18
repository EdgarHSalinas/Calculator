//
//  ViewController.swift
//  Calculator
//
//  Created by Edgar Salinas on 5/31/17.
//  Copyright © 2017 EHS LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {


    
    
    
    @IBOutlet weak var display: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    private var userIsTyping = false
    
    @IBAction private func touchDigit(_ sender: UIButton) {
        
        let digit = sender.currentTitle!
        
        if userIsTyping {
            
            let textCurrentlyInDisplay = display.text!
            
            if digit != "." || textCurrentlyInDisplay.range(of: ".") == nil {
                display.text = textCurrentlyInDisplay + digit
            }
        } else {
            
            if digit == "." {
                let textCurrentlyInDisplay = display.text!
                display.text = textCurrentlyInDisplay + digit
            } else {
                display.text = digit
            }
            
            userIsTyping = true
            
        }
    }
    
 
     var displayValue: Double? {
        
        get {
            if let text = display.text, let value = NumberFormatter().number(from: text) {
                return value as? Double
            }
            return nil
  
        } set {
        if newValue != nil {
            let decimalFormatter = NumberFormatter()
    
            decimalFormatter.numberStyle = .decimal
            decimalFormatter.maximumFractionDigits = 4
            display.text = decimalFormatter.string(from: newValue! as NSNumber)
            descriptionLabel.text = brain.description
        } else {
            display.text = "0"
            descriptionLabel.text = " "
            userIsTyping = false
    
        }
    
    
    }
    
        
}

    // Computed Property
  /*
    var displayValue: Double {
        get {
            return Double(display.text!)!
                
                //NumberFormatter().number(from: (display.text!) as? Double
                
                //(NumberFormatter().number(from: display.text!)?.doubleValue)!
            
        }
        set {
            display.text = String(describing: newValue)
        }
    }

   */
    private var brain = CalculatorBrain()
    
    
    @IBAction func performOperation(_ sender: UIButton) {
        if userIsTyping {
            if displayValue != nil {
            brain.setOperand(displayValue!)
            userIsTyping = false
            }
        }
        
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        if let result = brain.result {
            displayValue = result
        }
        
        descriptionLabel.text = brain.description
    }

}

