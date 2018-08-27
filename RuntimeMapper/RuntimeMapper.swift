//
//  RuntimeMapper.swift
//  RuntimeMapper
//
//  Created by 안덕환 on 26/07/2018.
//  Copyright © 2018 thekan. All rights reserved.
//

import Foundation
import Runtime


public struct InstanceParseInfo {
    public let key: String
    public let fromType: Any.Type
    public let toType: Any.Type
    public let parseType: ParseType
}

public struct JsonParseInfo {
    public let key: String
    public let toType: Any.Type
    public let parseType: ParseType
}

public enum ParseType {
    case array
    case object
}

public class RuntimeMapper {
    private var jsonParseInfos: [JsonParseInfo] = []
    private var instanceParseInfos: [InstanceParseInfo] = []
    
    private enum MappingType {
        case json, instance
    }
    
    public init() { }
    
    public init(jsonParseInfos: [JsonParseInfo]) {
        self.jsonParseInfos = jsonParseInfos
    }
    
    public init(instanceParseInfos: [InstanceParseInfo]) {
        self.instanceParseInfos = instanceParseInfos
    }
    
    private func findJsonParseInfo(by key: String) -> JsonParseInfo? {
        return jsonParseInfos.first(where: { $0.key == key })
    }
    
    private func findInstanceParseInfo(by key: String) -> InstanceParseInfo? {
        return instanceParseInfos.first(where: { $0.key == key })
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
            case ValueType.intType, ValueType.optionalIntType:
                if let intValue = value as? Int {
                    try propertyInfo.set(value: intValue, on: &instance)
                }
            case ValueType.arrayIntType, ValueType.arrayOptionalIntType:
                if let intArrayValue = value as? [Int] {
                    try propertyInfo.set(value: intArrayValue, on: &instance)
                }
            case ValueType.optionalArrayIntType, ValueType.optionalArrayOptionalIntType:
                if let intArrayValue = value as? [Int] {
                    try propertyInfo.set(value: intArrayValue, on: &instance)
                }
            // Float
            case ValueType.floatType, ValueType.optionalFloatType:
                if let numberValue = value as? NSNumber {
                    try propertyInfo.set(value: numberValue.floatValue, on: &instance)
                }
            case ValueType.arrayFloatType, ValueType.arrayOptionalFloatType:
                if let numberArrayValue = value as? [NSNumber] {
                    let floatArray = numberArrayValue.map { $0.floatValue }
                    try propertyInfo.set(value: floatArray, on: &instance)
                }
            case ValueType.optionalArrayFloatType, ValueType.optionalArrayOptionalFloatType:
                if let numberArrayValue = value as? [NSNumber] {
                    let floatArray = numberArrayValue.map { $0.floatValue }
                    try propertyInfo.set(value: floatArray, on: &instance)
                }
            // Double
            case ValueType.doubleType, ValueType.optionalDoubleType:
                if let numberValue = value as? NSNumber {
                    try propertyInfo.set(value: numberValue.doubleValue, on: &instance)
                }
            case ValueType.arrayDoubleType, ValueType.arrayOptionalDoubleType:
                if let numberArrayValue = value as? [NSNumber] {
                    let floatArray = numberArrayValue.map { $0.doubleValue }
                    try propertyInfo.set(value: floatArray, on: &instance)
                }
            case ValueType.optionalArrayDoubleType, ValueType.optionalArrayOptionalDoubleType:
                if let numberArrayValue = value as? [NSNumber] {
                    let floatArray = numberArrayValue.map { $0.doubleValue }
                    try propertyInfo.set(value: floatArray, on: &instance)
                }
            // Bool
            case ValueType.boolType, ValueType.optionalBoolType:
                if let numberValue = value as? NSNumber {
                    try propertyInfo.set(value: numberValue.boolValue, on: &instance)
                }
            case ValueType.arrayBoolType, ValueType.arrayOptionalBoolType:
                if let numberArrayValue = value as? [NSNumber] {
                    let boolArray = numberArrayValue.map { $0.boolValue }
                    try propertyInfo.set(value: boolArray, on: &instance)
                }
            case ValueType.optionalArrayBoolType, ValueType.optionalArrayOptionalBoolType:
                if let numberArrayValue = value as? [NSNumber] {
                    let boolArray = numberArrayValue.map { $0.boolValue }
                    try propertyInfo.set(value: boolArray, on: &instance)
                }
            // String
            case ValueType.stringType, ValueType.optionalStringType:
                if let stringValue = value as? String {
                    try propertyInfo.set(value: stringValue, on: &instance)
                }
            case ValueType.arrayStringType, ValueType.arrayOptionalStringType:
                if let stringArray = value as? [String] {
                    try propertyInfo.set(value: stringArray, on: &instance)
                }
            case ValueType.optionalArrayStringType, ValueType.optionalArrayOptionalStringType:
                if let stringArray = value as? [String] {
                    try propertyInfo.set(value: stringArray, on: &instance)
                }
            // NSNumber
            case ValueType.numberType, ValueType.optionalNumberType:
                if let numberValue = value as? NSNumber {
                    try propertyInfo.set(value: numberValue, on: &instance)
                }
            case ValueType.arrayNumberType, ValueType.arrayOptionalNumberType:
                if let numberArray = value as? [NSNumber] {
                    try propertyInfo.set(value: numberArray, on: &instance)
                }
            case ValueType.optionalArrayNumberType, ValueType.optionalArrayOptionalNumberType:
                if let numberArray = value as? [NSNumber] {
                    try propertyInfo.set(value: numberArray, on: &instance)
                }
            // Besides default value
            default:
                switch mappingType {
                case .instance:
                    guard let instanceParseInfo = findInstanceParseInfo(by: propertyInfo.name) else {
                        return
                    }
                    try setInstanceValue(from: value, to: propertyInfo, with: instanceParseInfo, in: &instance)
                case .json:
                    guard let jsonParseInfo = findJsonParseInfo(by: propertyInfo.name) else {
                        return
                    }
                    try setJsonValue(from: value, to: propertyInfo, with: jsonParseInfo, in: &instance)
                }
            }
        } catch {
            throw error
        }
    }
    
    private func setJsonValue<T>(from jsonValue: Any, to propertyInfo: PropertyInfo, with parseInfo: JsonParseInfo, in instance: inout T) throws {
        guard let jsonString = convertToJson(from: jsonValue, type: parseInfo.parseType) else {
            return
        }
        
        do {
            switch parseInfo.parseType {
            case .object:
                let object = try readObject(from: jsonString, with: parseInfo.toType)
                try propertyInfo.set(value: object, on: &instance)
            case .array:
                let array = try readArray(from: jsonString, with: parseInfo.toType)
                try propertyInfo.set(value: array, on: &instance)
            }
        } catch {
            throw error
        }
    }
    
    private func setInstanceValue<F, T>(from object: F, to propertyInfo: PropertyInfo, with parseInfo: InstanceParseInfo, in instance: inout T) throws {
        do {
            switch parseInfo.parseType {
            case .object:
                let object = try readObject(from: object, fromType: parseInfo.fromType, toType: parseInfo.toType)
                try propertyInfo.set(value: object, on: &instance)
            case .array:
                guard let objectList = object as? [F] else {
                    throw RuntimeMapperErrors.UnsupportedType
                }
                let array = try readArray(from: objectList, fromType: parseInfo.fromType, toType: parseInfo.toType)
                try propertyInfo.set(value: array, on: &instance)
            }
        } catch {
            throw error
        }
    }
}

extension RuntimeMapper {
    private func readObject<F>(from instance: F, fromType: Any.Type, toType: Any.Type) throws -> Any {
        guard let toInfo = try? typeInfo(of: fromType), var instance = try? createInstance(of: toType) else {
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
    
    public func readArray<F>(from instances: [F], fromType: Any.Type, toType: Any.Type) throws -> [Any] {
        guard let toInfo = try? typeInfo(of: fromType) else {
            throw RuntimeMapperErrors.UnsupportedType
        }
        
        let mappedDicts = InstanceHelper.convertToDictionaries(from: instances)
        var instanceList: [Any] = []
        
        for mappedDict in mappedDicts {
            guard var instance = try? createInstance(of: toType) else {
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
