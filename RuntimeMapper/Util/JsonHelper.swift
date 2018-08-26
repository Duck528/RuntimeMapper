//
//  JsonHelper.swift
//  RuntimeMapper
//
//  Created by 안덕환 on 30/07/2018.
//  Copyright © 2018 thekan. All rights reserved.
//

import Foundation

class JsonHelper {
    
    enum JsonType {
        case object(jsonDict: [String: Any])
        case list(jsonDicts: [[String: Any]])
    }
    
    enum Errors: Error {
        case invalidJsonFormat
    }
    
    static func convertToJsonString(from dictionary: [String: Any]) -> String? {
        guard
            let jsonData = try? JSONSerialization.data(withJSONObject: dictionary, options: []),
            let jsonString = String(data: jsonData, encoding: .utf8) else {
                return nil
        }
        return jsonString
    }
    
    static func convertToJsonString(from dictionaries: [[String: Any]]) -> String? {
        guard
            let jsonData = try? JSONSerialization.data(withJSONObject: dictionaries, options: []),
            let jsonString = String(data: jsonData, encoding: .utf8) else {
                return nil
        }
        return jsonString
    }
    
    static func convertToDictionary(from jsonString: String) throws -> JsonType {
        guard
            let jsonData = jsonString.data(using: .utf8),
            let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) else {
                throw Errors.invalidJsonFormat
        }
        
        if let jsonDict = json as? [String: Any] {
            return .object(jsonDict: jsonDict)
        } else if let jsonDicts = json as? [[String: Any]] {
            return .list(jsonDicts: jsonDicts)
        } else {
            throw Errors.invalidJsonFormat
        }
    }
    
    static func convertToDictionary(from jsonString: String, with keys: [String]) -> [String: Any] {
        guard
            let jsonData = jsonString.data(using: .utf8),
            let json = try? JSONSerialization.jsonObject(with: jsonData, options: []),
            let jsonDict = json as? [String: Any] else {
                return [:]
        }
        var dict: [String: Any] = [:]
        for key in jsonDict.keys {
            dict[key] = jsonDict[key]
        }
        return dict
    }
    
    static func convertToDictionaries(from jsonString: String, with keys: [String]) -> [[String: Any]] {
        guard
            let jsonData = jsonString.data(using: .utf8),
            let json = try? JSONSerialization.jsonObject(with: jsonData, options: []),
            let jsonDicts = json as? [[String: Any]] else {
                return [[:]]
        }
        var dicts: [[String: Any]] = []
        for jsonDict in jsonDicts {
            var dict: [String: Any] = [:]
            for key in jsonDict.keys {
                dict[key] = jsonDict[key]
            }
            dicts.append(dict)
        }
        return dicts
    }
}
