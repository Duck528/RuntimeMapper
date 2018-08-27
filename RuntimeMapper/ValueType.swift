//
//  ValueType.swift
//  RuntimeMapper
//
//  Created by 안덕환 on 28/08/2018.
//  Copyright © 2018 thekan. All rights reserved.
//

import Foundation


class ValueType {
    static let intType = String(describing: Int.self)
    static let optionalIntType = String(describing: Int?.self)
    static let arrayIntType = String(describing: [Int].self)
    static let arrayOptionalIntType = String(describing: [Int?].self)
    static let optionalArrayIntType = String(describing: [Int]?.self)
    static let optionalArrayOptionalIntType = String(describing: [Int?]?.self)
    
    static let floatType = String(describing: Float.self)
    static let optionalFloatType = String(describing: Float?.self)
    static let arrayFloatType = String(describing: [Float].self)
    static let arrayOptionalFloatType = String(describing: [Float?].self)
    static let optionalArrayFloatType = String(describing: [Float]?.self)
    static let optionalArrayOptionalFloatType = String(describing: [Float?]?.self)
    
    static let doubleType = String(describing: Double.self)
    static let optionalDoubleType = String(describing: Double?.self)
    static let arrayDoubleType = String(describing: [Double].self)
    static let arrayOptionalDoubleType = String(describing: [Double?].self)
    static let optionalArrayDoubleType = String(describing: [Double]?.self)
    static let optionalArrayOptionalDoubleType = String(describing: [Double?]?.self)
    
    static let boolType = String(describing: Bool.self)
    static let optionalBoolType = String(describing: Bool?.self)
    static let arrayBoolType = String(describing: [Bool].self)
    static let arrayOptionalBoolType = String(describing: [Bool?].self)
    static let optionalArrayBoolType = String(describing: [Bool]?.self)
    static let optionalArrayOptionalBoolType = String(describing: [Bool?]?.self)
    
    static let stringType = String(describing: String.self)
    static let optionalStringType = String(describing: String?.self)
    static let arrayStringType = String(describing: [String].self)
    static let arrayOptionalStringType = String(describing: [String?].self)
    static let optionalArrayStringType = String(describing: [String]?.self)
    static let optionalArrayOptionalStringType = String(describing: [String?]?.self)
    
    static let numberType = String(describing: NSNumber.self)
    static let optionalNumberType = String(describing: NSNumber?.self)
    static let arrayNumberType = String(describing: [NSNumber].self)
    static let arrayOptionalNumberType = String(describing: [NSNumber?].self)
    static let optionalArrayNumberType = String(describing: [NSNumber]?.self)
    static let optionalArrayOptionalNumberType = String(describing: [NSNumber?]?.self)
}
