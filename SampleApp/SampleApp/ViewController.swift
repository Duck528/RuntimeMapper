//
//  ViewController.swift
//  SampleApp
//
//  Created by 안덕환 on 30/07/2018.
//  Copyright © 2018 thekan. All rights reserved.
//

import UIKit
import RuntimeMapper
import SwiftyJSON
import Runtime

class User {
    var name: String = ""
    var age: Int = 0
    var blog: Blog = Blog()
}

class Blog {
    var id: Int? = 0
    var url: String = ""
    var name: String = ""
    var value: Float = 0
    var isSecret: Bool = true
    var doubleValue: Double = 0
}

class ViewController: UIViewController {
    
    let jsonNestedString =
    """
    {
        "name": "thekan",
        "age": 24,
        "blog": {
            "id": 111,
            "url": "http://roadfiresoftware.com/blog/",
            "name": "Roadfire Software Blog",
            "value": 1231.11,
            "doubleValue": 123213.12322,
            "isSecret": false
        }
    }
    """
    
    let jsonArrayString =
    """
    [{
        "id": 111,
        "url": "http://roadfiresoftware.com/blog/",
        "name": "Roadfire Software Blog",
        "value": 1231.11,
        "doubleValue": 81232.12322,
        "isSecret": false
        },
        {
        "id": 123,
        "url": "http://thekan.blog.com",
        "name": "thekan",
        "value": 21312.11123,
        "doubleValue": 123213.12322,
        "isSecret": true
    }]
    """
    
    let jsonSigleString =
    """
    {
        "id": 111,
        "url": "http://roadfiresoftware.com/blog/",
        "name": "Roadfire Software Blog",
        "value": 1231.11,
        "doubleValue": 123213.12322,
        "isSecret": false
    }
    """

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let runtimeMapper = RuntimeMapper()
        if let user = try? runtimeMapper.readSingle(from: jsonNestedString, initializer: User.init) {
            print("name: \(user.name)")
            print("age: \(user.age)")
            print("blog name: \(user.blog.name)")
        }
    }
}

