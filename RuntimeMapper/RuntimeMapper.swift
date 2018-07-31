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
                print("type: \(Swift.type(of: value))")
                try? propertyInfo.set(value: value, on: &instance)
            }
        }
        return instance
    }
    
    public init() { }
}
