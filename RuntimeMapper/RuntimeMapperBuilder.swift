//
//  RuntimeMapperBuilder.swift
//  RuntimeMapper
//
//  Created by 안덕환 on 28/08/2018.
//  Copyright © 2018 thekan. All rights reserved.
//

import Foundation


public class RuntimeMapperBuilder {
    private var parseInfos: [ParseInfo] = []
    
    public func setParseInfo(_ parseInfo: ParseInfo) -> RuntimeMapperBuilder {
        parseInfos.append(parseInfo)
        return self
    }
    
    public func build() -> RuntimeMapper {
        let runtimeMapper = RuntimeMapper(parseInfos: parseInfos)
        return runtimeMapper
    }
}
