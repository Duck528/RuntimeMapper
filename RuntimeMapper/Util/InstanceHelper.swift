//
//  InstanceHelper.swift
//  RuntimeMapper
//
//  Created by 안덕환 on 17/08/2018.
//  Copyright © 2018 thekan. All rights reserved.
//

import Foundation
import Runtime


class InstanceHelper {
    
    enum Errors: Error {
        case ParseInstanceError
    }
    
    static func convertToDictionary<T>(from instance: T, instanceType: Any.Type) -> [String: Any] {
        guard let typeInfo = try? typeInfo(of: instanceType) else {
            return [:]
        }
        print("instance: \(instance), type: \(String(describing: instanceType))")
        var dict: [String: Any] = [:]
        for property in typeInfo.properties {
            print("propertyName: \(property.name)")
            if let value = try? property.get(from: instance) {
                dict[property.name] = value
            }
        }
        return dict
    }
    
    static func convertToDictionary<T>(from instance: T) -> [String: Any] {
        guard let typeInfo = try? typeInfo(of: T.self) else {
            return [:]
        }
        var dict: [String: Any] = [:]
        for property in typeInfo.properties {
            if let value = try? property.get(from: instance) {
                dict[property.name] = value
            }
        }
        return dict
    }
    
    static func convertToDictionaries<T>(from instances: [T]) -> [[String: Any]] {
        guard let typeInfo = try? typeInfo(of: T.self) else {
            return []
        }
        var dicts: [[String: Any]] = [[:]]
        for inst in instances {
            var dict: [String: Any] = [:]
            for property in typeInfo.properties {
                if let value = try? property.get(from: inst) {
                    dict[property.name] = value
                }
            }
            dicts.append(dict)
        }
        return dicts
    }
    
    static func convertToDictionaries<T>(from instances: [T], instanceType: Any.Type) -> [[String: Any]] {
        guard let typeInfo = try? typeInfo(of: instanceType) else {
            return []
        }
        var dicts: [[String: Any]] = [[:]]
        for inst in instances {
            var dict: [String: Any] = [:]
            for property in typeInfo.properties {
                if let value = try? property.get(from: inst) {
                    dict[property.name] = value
                }
            }
            dicts.append(dict)
        }
        return dicts
    }
}
