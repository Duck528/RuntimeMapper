//
//  RuntimeInstanceMapperBuilder.swift
//  RuntimeMapper
//
//  Created by 안덕환 on 28/08/2018.
//  Copyright © 2018 thekan. All rights reserved.
//

import Foundation


public class RuntimeInstanceMapperBuilder {
    private var parseInfos: [InstanceParseInfo] = []
    
    public func setParseInfo(_ parseInfo: InstanceParseInfo) -> RuntimeInstanceMapperBuilder {
        parseInfos.append(parseInfo)
        return self
    }
    
    public func setParseInfo(key: String, fromType: Any.Type, toType: Any.Type, parseType: ParseType) -> RuntimeInstanceMapperBuilder {
        let parseInfo = InstanceParseInfo(key: key, fromType: fromType, toType: toType, parseType: parseType)
        parseInfos.append(parseInfo)
        return self
    }
    
    public func build() -> RuntimeMapper {
        let runtimeMapper = RuntimeMapper(instanceParseInfos: parseInfos)
        return runtimeMapper
    }
    
    public init() { }
}
