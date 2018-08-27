//
//  RuntimeJsonMapperBuilder.swift
//  RuntimeMapper
//
//  Created by 안덕환 on 28/08/2018.
//  Copyright © 2018 thekan. All rights reserved.
//

import Foundation

public class RuntimeJsonMapperBuilder {
    private var parseInfos: [JsonParseInfo] = []
    
    public func setParseInfo(_ parseInfo: JsonParseInfo) -> RuntimeJsonMapperBuilder {
        parseInfos.append(parseInfo)
        return self
    }
    
    public func setParseInfo(key: String, toType: Any.Type, parseType: ParseType) -> RuntimeJsonMapperBuilder {
        let parseInfo = JsonParseInfo(key: key, toType: toType, parseType: parseType)
        parseInfos.append(parseInfo)
        return self
    }
    
    public func build() -> RuntimeMapper {
        let runtimeMapper = RuntimeMapper(jsonParseInfos: parseInfos)
        return runtimeMapper
    }
    
    public init() { }
}
