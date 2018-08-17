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
    case object
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
    
    private let numberType = String(describing: NSNumber.self)
    private let optionalNumberType = String(describing: NSNumber?.self)
    private let arrayNumberType = String(describing: [NSNumber].self)
    private let arrayOptionalNumberType = String(describing: [NSNumber?].self)
    private let optionalArrayNumberType = String(describing: [NSNumber]?.self)
    private let optionalArrayOptionalNumberType = String(describing: [NSNumber?]?.self)
    
    private enum MappingType {
        case json, instance
    }
    
    private func findParseInfo(by key: String) -> ParseInfo? {
        return parseInfos.first(where: { $0.key == key })
    }
    
    public func register(key: String, classType: Any.Type, parseType: ParseType) {
        parseInfos.append(ParseInfo(key: key, classType: classType, parseType: parseType))
    }
    
    public func readObject<F, T>(from instance: F, initializer: (() -> T)) throws -> T {
        guard let toInfo = try? typeInfo(of: T.self) else {
            throw RuntimeMapperErrors.UnsupportedType
        }
        
        let mappedDict = InstanceHelper.convertToDictionary(from: instance)
        var toInstance = initializer()
        
        for toProperty in toInfo.properties {
            if let value = mappedDict[toProperty.name] {
                do {
                    try setValue(value, to: toProperty, in: &toInstance, mappingType: .instance)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        return toInstance
    }
    
    public func readArray<F, T>(from instances: [F], initializer: (() -> T)) throws -> [T] {
        guard let toInfo = try? typeInfo(of: T.self) else {
            throw RuntimeMapperErrors.UnsupportedType
        }
        
        let mappedDicts = InstanceHelper.convertToDictionaries(from: instances)
        var instanceList: [T] = []
        
        for mappedDict in mappedDicts {
            var inst = initializer()
            for toProperty in toInfo.properties {
                if let value = mappedDict[toProperty.name] {
                    do {
                        try setValue(value, to: toProperty, in: &inst, mappingType: .instance)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
            instanceList.append(inst)
        }
        return instanceList
    }
    
    public func readObject<T>(from jsonString: String, initializer: (() -> T)) throws -> T {
        guard let info = try? typeInfo(of: T.self) else {
            throw RuntimeMapperErrors.UnsupportedType
        }
        
        let propertyNames = info.properties.map { $0.name }
        let mappedDict = JsonHelper.convertToDictionary(from: jsonString, with: propertyNames)
        
        var instance = initializer()
        for p in info.properties {
            if let value = mappedDict[p.name] {
                do {
                    try setValue(value, to: p, in: &instance, mappingType: .json)
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
                        try setValue(value, to: p, in: &instance, mappingType: .json)
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
        case .object:
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
    
    private func setValue<T>(_ value: Any, to propertyInfo: PropertyInfo, in instance: inout T, mappingType: MappingType) throws {
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
            // NSNumber
            case numberType, optionalNumberType:
                if let numberValue = value as? NSNumber {
                    try propertyInfo.set(value: numberValue, on: &instance)
                }
            case arrayNumberType, arrayOptionalNumberType, optionalArrayNumberType, optionalArrayOptionalNumberType:
                if let numberArray = value as? [NSNumber] {
                    try propertyInfo.set(value: numberArray, on: &instance)
                }
            // Besides default value
            default:
                guard let findedParseInfo = findParseInfo(by: propertyInfo.name) else {
                    return
                }
                
                switch mappingType {
                case .instance:
                    try setInstanceValue(from: value, to: propertyInfo, with: findedParseInfo, in: &instance)
                case .json:
                    try setJsonValue(from: value, to: propertyInfo, with: findedParseInfo, in: &instance)
                }
            }
        } catch {
            throw error
        }
    }
    
    private func setJsonValue<T>(from jsonValue: Any, to propertyInfo: PropertyInfo, with parseInfo: ParseInfo, in instance: inout T) throws {
        guard let jsonString = convertToJson(from: jsonValue, type: parseInfo.parseType) else {
            return
        }
        
        do {
            switch parseInfo.parseType {
            case .object:
                let object = try readObject(from: jsonString, with: parseInfo.classType)
                try propertyInfo.set(value: object, on: &instance)
            case .array:
                let array = try readArray(from: jsonString, with: parseInfo.classType)
                try propertyInfo.set(value: array, on: &instance)
            }
        } catch {
            throw error
        }
    }
    
    private func setInstanceValue<F, T>(from object: F, to propertyInfo: PropertyInfo, with parseInfo: ParseInfo, in instance: inout T) throws {
        do {
            switch parseInfo.parseType {
            case .object:
                let object = try readObject(from: object, with: parseInfo.classType)
                try propertyInfo.set(value: object, on: &instance)
            case .array:
                guard let objectList = object as? [F] else {
                    throw RuntimeMapperErrors.UnsupportedType
                }
                let array = try readArray(from: objectList, with: parseInfo.classType)
                try propertyInfo.set(value: array, on: &instance)
            }
        } catch {
            throw error
        }
    }
}

extension RuntimeMapper {
    private func readObject<F>(from instance: F, with type: Any.Type) throws -> Any {
        guard let toInfo = try? typeInfo(of: F.self), var instance = try? createInstance(of: type) else {
            throw RuntimeMapperErrors.UnsupportedType
        }
        
        let mappedDict = InstanceHelper.convertToDictionary(from: instance)
        for toProperty in toInfo.properties {
            if let value = mappedDict[toProperty.name] {
                do {
                    try setValue(value, to: toProperty, in: &instance, mappingType: .instance)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        return instance
    }
    
    public func readArray<F>(from instances: [F], with type: Any.Type) throws -> [Any] {
        guard let toInfo = try? typeInfo(of: F.self) else {
            throw RuntimeMapperErrors.UnsupportedType
        }
        
        let mappedDicts = InstanceHelper.convertToDictionaries(from: instances)
        var instanceList: [Any] = []
        
        for mappedDict in mappedDicts {
            guard var instance = try? createInstance(of: type) else {
                break
            }
            for toProperty in toInfo.properties {
                if let value = mappedDict[toProperty.name] {
                    do {
                        try setValue(value, to: toProperty, in: &instance, mappingType: .instance)
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

extension RuntimeMapper {
    private func readObject(from jsonString: String, with type: Any.Type) throws -> Any {
        guard let info = try? typeInfo(of: type.self), var instance = try? createInstance(of: type) else {
            throw RuntimeMapperErrors.UnsupportedType
        }
        
        let propertyNames = info.properties.map { $0.name }
        let mappedDict = JsonHelper.convertToDictionary(from: jsonString, with: propertyNames)
        
        for p in info.properties {
            if let value = mappedDict[p.name] {
                do {
                    try setValue(value, to: p, in: &instance, mappingType: .json)
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
                        try setValue(value, to: p, in: &instance, mappingType: .json)
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
