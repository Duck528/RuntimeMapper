//
//  RuntimeMapper.swift
//  RuntimeMapper
//
//  Created by 안덕환 on 26/07/2018.
//  Copyright © 2018 thekan. All rights reserved.
//

import Foundation
import Runtime


public class RuntimeMapper {
    public func read<T>(from jsonString: String, initializer: (() -> T)) throws -> T {
        guard let info = try? typeInfo(of: T.self) else {
            throw RuntimeMapperErrors.UnsupportedType
        }
        let propertyNames = info.properties.map { $0.name }
        let mappedDict = JsonHelper.convertToDictionary(from: jsonString, with: propertyNames)
        
        var instance = initializer()
        for p in info.properties {
            if let propertyInfo = try? info.property(named: p.name), let value = mappedDict[p.name] {
                switch value {
                case is Int:
                    try? propertyInfo.set(value: value as! Int, on: &instance)
                case is String:
                    try? propertyInfo.set(value: value as! String, on: &instance)
                case is Float:
                    try? propertyInfo.set(value: value as! Float, on: &instance)
                case is Double:
                    try? propertyInfo.set(value: value as! Double, on: &instance)
                default:
                    break
                }
                
            }
        }
        return instance
    }
    
    public init() { }
}
