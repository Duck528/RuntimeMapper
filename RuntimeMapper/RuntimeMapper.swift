//
//  RuntimeMapper.swift
//  RuntimeMapper
//
//  Created by 안덕환 on 26/07/2018.
//  Copyright © 2018 thekan. All rights reserved.
//

import Foundation
import Runtime


public struct ParseInfo {
    let key: String
    let classType: Any.Type
    let parseType: ParseType
}

public enum ParseType {
    case array
    case single
}

public class RuntimeMapper {
    
    private var parseInfos: [ParseInfo] = []
    
    private let intType = String(describing: Int.self)
    private let optionalIntType = String(describing: Int?.self)
    private let arrayIntType = String(describing: [Int].self)
    private let arrayOptionalIntType = String(describing: [Int?].self)
    private let optionalArrayIntType = String(describing: [Int]?.self)
    private let optionalArrayOptionalIntType = String(describing: [Int?]?.self)
    
    private let floatType = String(describing: Float.self)
    private let optionalFloatType = String(describing: Float?.self)
    private let arrayFloatType = String(describing: [Float].self)
    private let arrayOptionalFloatType = String(describing: [Float?].self)
    private let optionalArrayFloatType = String(describing: [Float]?.self)
    private let optionalArrayOptionalFloatType = String(describing: [Float?]?.self)
    
    private let doubleType = String(describing: Double.self)
    private let optionalDoubleType = String(describing: Double?.self)
    private let arrayDoubleType = String(describing: [Double].self)
    private let arrayOptionalDoubleType = String(describing: [Double?].self)
    private let optionalArrayDoubleType = String(describing: [Double]?.self)
    private let optionalArrayOptionalDoubleType = String(describing: [Double?]?.self)
    
    private let boolType = String(describing: Bool.self)
    private let optionalBoolType = String(describing: Bool?.self)
    private let arrayBoolType = String(describing: [Bool].self)
    private let arrayOptionalBoolType = String(describing: [Bool?].self)
    private let optionalArrayBoolType = String(describing: [Bool]?.self)
    private let optionalArrayOptionalBoolType = String(describing: [Bool?]?.self)
    
    private let stringType = String(describing: String.self)
    private let optionalStringType = String(describing: String?.self)
    private let arrayStringType = String(describing: [String].self)
    private let arrayOptionalStringType = String(describing: [String?].self)
    private let optionalArrayStringType = String(describing: [String]?.self)
    private let optionalArrayOptionalStringType = String(describing: [String?]?.self)
    
    private func findParseInfo(by key: String) -> ParseInfo? {
        return parseInfos.first(where: { $0.key == key })
    }
    
    public func register(key: String, classType: Any.Type, parseType: ParseType) {
        parseInfos.append(ParseInfo(key: key, classType: classType, parseType: parseType))
    }
    
    public func readSingle<T>(from jsonString: String, initializer: (() -> T)) throws -> T {
        guard let info = try? typeInfo(of: T.self) else {
            throw RuntimeMapperErrors.UnsupportedType
        }
        
        let propertyNames = info.properties.map { $0.name }
        let mappedDict = JsonHelper.convertToDictionary(from: jsonString, with: propertyNames)
        
        var instance = initializer()
        for p in info.properties {
            if let value = mappedDict[p.name] {
                do {
                    try setValue(value, to: p, in: &instance)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        return instance
    }
    
    public func readArray<T>(from jsonString: String, initializer: (() -> T)) throws -> [T] {
        guard let info = try? typeInfo(of: T.self) else {
            throw RuntimeMapperErrors.UnsupportedType
        }
        let propertyNames = info.properties.map { $0.name }
        let mappedDicts = JsonHelper.convertToDictionaries(from: jsonString, with: propertyNames)
        
        var instanceList: [T] = []
        for mappedDict in mappedDicts {
            var instance = initializer()
            for p in info.properties {
                if let value = mappedDict[p.name] {
                    do {
                        try setValue(value, to: p, in: &instance)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
            instanceList.append(instance)
        }
        return instanceList
    }
    
    public init() { }
}

extension RuntimeMapper {
    
    private func convertToJson(from value: Any, type: ParseType) -> String? {
        switch type {
        case .single:
            guard
                let dict = value as? [String: Any],
                let jsonString = JsonHelper.convertToJsonString(from: dict) else {
                    return nil
            }
            return jsonString
        case .array:
            guard
                let dicts = value as? [[String: Any]],
                let jsonString = JsonHelper.convertToJsonString(from: dicts) else {
                    return nil
            }
            return jsonString
        }
    }
    
    private func setValue<T>(_ value: Any, to propertyInfo: PropertyInfo, in instance: inout T) throws {
        do {
            switch String(describing: propertyInfo.type) {
            // Int
            case intType, optionalIntType:
                if let intValue = value as? Int {
                    try propertyInfo.set(value: intValue, on: &instance)
                }
            case arrayIntType, arrayOptionalIntType, optionalArrayIntType, optionalArrayOptionalIntType:
                if let intArrayValue = value as? [Int] {
                    try propertyInfo.set(value: intArrayValue, on: &instance)
                }
            // Float
            case floatType, optionalFloatType:
                if let numberValue = value as? NSNumber {
                    try propertyInfo.set(value: numberValue.floatValue, on: &instance)
                }
            case arrayFloatType, arrayOptionalFloatType, optionalArrayFloatType, optionalArrayOptionalFloatType:
                if let numberArrayValue = value as? [NSNumber] {
                    let floatArray = numberArrayValue.map { $0.floatValue }
                    try propertyInfo.set(value: floatArray, on: &instance)
                }
            // Double
            case doubleType, optionalDoubleType:
                if let numberValue = value as? NSNumber {
                    try propertyInfo.set(value: numberValue.doubleValue, on: &instance)
                }
            case arrayDoubleType, arrayOptionalDoubleType, optionalArrayDoubleType, optionalArrayOptionalDoubleType:
                if let numberArrayValue = value as? [NSNumber] {
                    let floatArray = numberArrayValue.map { $0.doubleValue }
                    try propertyInfo.set(value: floatArray, on: &instance)
                }
            // Bool
            case boolType, optionalBoolType:
                if let numberValue = value as? NSNumber {
                    try propertyInfo.set(value: numberValue.boolValue, on: &instance)
                }
            case arrayBoolType, arrayOptionalBoolType, optionalArrayBoolType, optionalArrayOptionalBoolType:
                if let numberArrayValue = value as? [NSNumber] {
                    let boolArray = numberArrayValue.map { $0.boolValue }
                    try propertyInfo.set(value: boolArray, on: &instance)
                }
            // String
            case stringType, optionalStringType:
                if let stringValue = value as? String {
                    try propertyInfo.set(value: stringValue, on: &instance)
                }
            case arrayStringType, arrayOptionalStringType, optionalArrayStringType, optionalArrayOptionalStringType:
                if let stringArray = value as? [String] {
                    try propertyInfo.set(value: stringArray, on: &instance)
                }
            default:
                guard
                    let findedParseInfo = findParseInfo(by: propertyInfo.name),
                    let jsonString = convertToJson(from: value, type: findedParseInfo.parseType) else {
                        return
                }
                
                switch findedParseInfo.parseType {
                case .array:
                    let array = try readArray(from: jsonString, with: findedParseInfo.classType)
                    try propertyInfo.set(value: array, on: &instance)
                case .single:
                    let object = try readSingle(from: jsonString, with: findedParseInfo.classType)
                    try propertyInfo.set(value: object, on: &instance)
                }
            }
        } catch {
            throw error
        }
    }
}

extension RuntimeMapper {
    private func readSingle(from jsonString: String, with type: Any.Type) throws -> Any {
        guard let info = try? typeInfo(of: type.self), var instance = try? createInstance(of: type) else {
            throw RuntimeMapperErrors.UnsupportedType
        }
        
        let propertyNames = info.properties.map { $0.name }
        let mappedDict = JsonHelper.convertToDictionary(from: jsonString, with: propertyNames)
        
        for p in info.properties {
            if let value = mappedDict[p.name] {
                do {
                    try setValue(value, to: p, in: &instance)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        return instance
    }
    
    private func readArray(from jsonString: String, with type: Any.Type) throws -> [Any] {
        guard let info = try? typeInfo(of: type.self) else {
            throw RuntimeMapperErrors.UnsupportedType
        }
        let propertyNames = info.properties.map { $0.name }
        let mappedDicts = JsonHelper.convertToDictionaries(from: jsonString, with: propertyNames)
        
        var instanceList: [Any] = []
        for mappedDict in mappedDicts {
            guard var instance = try? createInstance(of: type) else {
                break
            }
            for p in info.properties {
                if let value = mappedDict[p.name] {
                    do {
                        try setValue(value, to: p, in: &instance)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
            instanceList.append(instance)
        }
        return instanceList
    }
}
