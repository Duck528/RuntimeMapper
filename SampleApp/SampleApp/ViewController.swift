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


class Blog {
    var id: Int = 0
    var url: String = ""
    var name: String = ""
    var value: Float = 0
    var isSecret: Bool = true
}

class ViewController: UIViewController {
    
    let jsonArrayString =
    """
    [{
        "id": 111,
        "url": "http://roadfiresoftware.com/blog/",
        "name": "Roadfire Software Blog",
        "value": 1231.11,
        "isSecret": false
        },
        {
        "id": 123,
        "url": "http://thekan.blog.com",
        "name": "thekan",
        "value": 21312.11123,
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
        "isSecret": false
    }
    """

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let runtimeMapper = RuntimeMapper()
        // SingleTest
//        if let blog = try? runtimeMapper.readSingle(from: jsonSigleString, initializer: Blog.init) {
//            print("id: \(blog.id)")
//            print("url \(blog.url)")
//            print("name: \(blog.name)")
//            print("value: \(blog.value)")
//            print("isSecret: \(blog.isSecret)")
//        }
        
        // ArrayTest
        if let blogs = try? runtimeMapper.readArray(from: jsonArrayString, initializer: Blog.init) {
            blogs.forEach {
                print("id: \($0.id)")
                print("url \($0.url)")
                print("name: \($0.name)")
                print("value: \($0.value)")
                print("isSecret: \($0.isSecret)")
            }
        }
    }
}

