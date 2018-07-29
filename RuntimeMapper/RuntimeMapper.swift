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
    public func read<T>(from string: String, initializer: (() -> T)) throws -> T {
        let instance = initializer()
        guard let typeInfo = try? typeInfo(of: T.self) else {
            throw RuntimeMapperErrors.UnsupportedType
        }
        typeInfo.properties.forEach {
            print($0.name)
        }
        return instance
    }
    
    public init() { }
}
