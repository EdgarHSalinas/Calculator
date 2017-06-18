//: Playground - noun: a place where people can play

import UIKit
import Foundation

var str = "Hello, playground"

let decimalFormatter = NumberFormatter()
decimalFormatter.numberStyle = .decimal

decimalFormatter.minimumFractionDigits = 0
decimalFormatter.maximumFractionDigits = 4

let myDouble1: Double = 8
let myString1 = decimalFormatter.string(for: myDouble1)
//let myString1 = percentFormatter.string(from: NSNumber(value: myDouble1)) // also works
print(String(describing: myString1)) // Optional("8.0%")

let myDouble2 = 8.5
let myString2 = decimalFormatter.string(for: myDouble2)
print(String(describing: myString2)) // Optional("8.5%")

let myDouble3 = 8.5786
let myString3 = decimalFormatter.string(for: myDouble3)
print(String(describing: myString3!)) // Optional("8.58%")
