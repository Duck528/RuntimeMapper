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
}

class ViewController: UIViewController {
    
    let jsonArrayString =
    """
    {
        "blogs": [
        {
        "id": 111,
        "url": "http://roadfiresoftware.com/blog/",
        "name": "Roadfire Software Blog"
        },
        {
        "id": 345,
        "url": "https://developer.apple.com/swift/blog/",
        "name": "Swift Developer Blog"
        }]
    }
    """
    let jsonSigleString =
    """
    {
        "id": 111,
        "url": "http://roadfiresoftware.com/blog/",
        "name": "Roadfire Software Blog",
        "value": 1231.11
    }
    """

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let runtimeMapper = RuntimeMapper()
        if let blog = try? runtimeMapper.read(from: jsonSigleString, initializer: Blog.init) {
            print("id: \(blog.id)")
            print("url \(blog.url)")
            print("name: \(blog.name)")
            print("value: \(blog.value)")
        }
    }
}

