//
//  Model.swift
//  SampleApp
//
//  Created by 안덕환 on 26/08/2018.
//  Copyright © 2018 thekan. All rights reserved.
//

import Foundation


class User {
    var name: String = ""
    var age: Int = 0
    var blog: Blog = Blog()
    var blogArray: [Blog] = []
}

class Human {
    var name: String = ""
    var age: Int = 0
    var blog: Blog?
    var blogArray: [Blog]?
}

class Blog {
    var id: Int? = 0
    var url: String = ""
    var name: String = ""
    var value: Float = 0
    var isSecret: Bool = true
    var doubleValue: Double = 0
    var userIds: [NSNumber] = []
}

class Site {
    var id: Int?
    var url: String?
    var name: String?
    var value: Float = 0
    var isSecret: Bool = false
    var doubleValue: Double = 0
    var userIds: [NSNumber]?
}
