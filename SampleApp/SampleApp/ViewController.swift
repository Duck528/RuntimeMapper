//
//  ViewController.swift
//  SampleApp
//
//  Created by 안덕환 on 30/07/2018.
//  Copyright © 2018 thekan. All rights reserved.
//

import UIKit
import RuntimeMapper

class User {
    var name = ""
    var age = 0
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let runtimeMapper = RuntimeMapper()
        try? runtimeMapper.read(from: "1234", initializer: User.init)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

