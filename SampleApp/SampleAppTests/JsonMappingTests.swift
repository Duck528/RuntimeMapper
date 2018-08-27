//
//  JsonMappingTests.swift
//  SampleAppTests
//
//  Created by 안덕환 on 23/08/2018.
//  Copyright © 2018 thekan. All rights reserved.
//

import XCTest
import RuntimeMapper
@testable import SampleApp

class JsonMappingTests: XCTestCase {
    
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
            "userIds": [1, 2, 3, 4, 5],
            "isSecret": false
        },
        "blogArray": [{
            "id": 111,
            "url": "https://qualitycoding.org/swift-mocking/",
            "name": "Conclusion: The basic configuration",
            "value": 1231212321.321,
            "doubleValue": 9123.12322,
            "userIds": [12, 132, 53, 24, 35],
            "isSecret": true
        },
        {
            "id": 1232,
            "url": "http://news.khan.co.kr/kh_news/khan_art_view.html?artid=201808261550001&code=940100&nv=stand&utm_source=naver&utm_medium=newsstand&utm_campaign=row1_1",
            "name": "article blog",
            "value": 1231.11,
            "doubleValue": 123213.12322,
            "userIds": [153, 132, 53, 24, 1235],
            "isSecret": false
        }]
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
    
    func testNestedJsonMapping() {
        // given
//        let runtimeMapper = RuntimeMapper()
//        runtimeMapper.register(key: "blog", classType: Blog.self, parseType: .object)
//        runtimeMapper.register(key: "blogArray", classType: Blog.self, parseType: .array)
//
        let runtimeMapper = RuntimeJsonMapperBuilder()
            .setParseInfo(key: "blog", toType: Blog.self, parseType: .object)
            .setParseInfo(key: "blogArray", toType: Blog.self, parseType: .array)
            .build()
        
        // when
        let user = try? runtimeMapper.readObject(from: jsonNestedString, initializer: User.init)
        XCTAssertNotNil(user, "user which created by runtimeMapper should be not nil")
        
        // then
        XCTAssertEqual(user!.name, "thekan")
        XCTAssertEqual(user!.age, 24)
        
        XCTAssertEqual(user!.blog.id, 111)
        XCTAssertEqual(user!.blog.url, "http://roadfiresoftware.com/blog/")
        XCTAssertEqual(user!.blog.name, "Roadfire Software Blog")
        XCTAssertEqual(user!.blog.value, 1231.11)
        XCTAssertEqual(user!.blog.doubleValue, 123213.12322)
        XCTAssertEqual(user!.blog.userIds, [1, 2, 3, 4, 5])
        XCTAssertEqual(user!.blog.isSecret, false)
        
        XCTAssertEqual(user!.blogArray.count, 2)
        
        XCTAssertEqual(user!.blogArray[0].id, 111)
        XCTAssertEqual(user!.blogArray[0].url, "https://qualitycoding.org/swift-mocking/")
        XCTAssertEqual(user!.blogArray[0].name, "Conclusion: The basic configuration")
        XCTAssertEqual(user!.blogArray[0].value, 1231212321.321)
        XCTAssertEqual(user!.blogArray[0].doubleValue, 9123.12322)
        XCTAssertEqual(user!.blogArray[0].userIds, [12, 132, 53, 24, 35])
        XCTAssertEqual(user!.blogArray[0].isSecret, true)
        
        XCTAssertEqual(user!.blogArray[1].id, 1232)
        XCTAssertEqual(
            user!.blogArray[1].url,
            "http://news.khan.co.kr/kh_news/khan_art_view.html?artid=201808261550001&code=940100&nv=stand&utm_source=naver&utm_medium=newsstand&utm_campaign=row1_1")
        XCTAssertEqual(user!.blogArray[1].name, "article blog")
        XCTAssertEqual(user!.blogArray[1].value, 1231.11)
        XCTAssertEqual(user!.blogArray[1].doubleValue, 123213.12322)
        XCTAssertEqual(user!.blogArray[1].userIds, [153, 132, 53, 24, 1235])
        XCTAssertEqual(user!.blogArray[1].isSecret, false)
    }
}
