//
//  InstanceMappingTests.swift
//  SampleAppTests
//
//  Created by 안덕환 on 23/08/2018.
//  Copyright © 2018 thekan. All rights reserved.
//

import XCTest
import RuntimeMapper
@testable import SampleApp


class InstanceMappingTests: XCTestCase {
    
    var runtimeMapper: RuntimeMapper!
    
    override func setUp() {
        super.setUp()
        
        runtimeMapper = RuntimeMapperBuilder()
            .setParseInfo(key: "blog", fromType: Blog.self, toType: Blog.self, parseType: .object)
            .setParseInfo(key: "blogArray", fromType: Blog.self, toType: Blog.self, parseType: .array)
            .build()
    }
    
    private func createBlog(name: String, doubleValue: Double, url: String, userIds: [NSNumber], value: Float, id: Int = 20, isSecret: Bool = false) -> Blog {
        let blog = Blog()
        blog.id = id
        blog.isSecret = isSecret
        blog.doubleValue = doubleValue
        blog.name = name
        blog.url = url
        blog.userIds = userIds
        blog.value = value
        return blog
    }
    
    func testBlogToSiteMapping() {
        let blog = createBlog(name: "hello world", doubleValue: 15, url: "http://www.naver.com", userIds: [1, 2, 3, 4, 5], value: 245, isSecret: true)
        let site = try? runtimeMapper.readObject(from: blog, initializer: Site.init)
        XCTAssertNotNil(site, "site should be not nil")
        
        XCTAssertEqual(site?.id, 20)
        XCTAssertEqual(site?.isSecret, true)
        XCTAssertEqual(site?.doubleValue, 15)
        XCTAssertEqual(site?.name, "hello world")
        XCTAssertEqual(site?.url, "http://www.naver.com")
        XCTAssertEqual(site?.userIds, [1, 2, 3, 4, 5])
        XCTAssertEqual(site?.value, 245)
    }
    
    func testUserToHumanMapping() {
        let user = User()
        user.age = 123
        user.name = "Ahn DeockHwan"
        user.blog = createBlog(
            name: "hello world",
            doubleValue: 15, url: "http://www.naver.com",
            userIds: [1, 2, 3, 4, 5],
            value: 245,
            isSecret: true)
        
        let blog01 = createBlog(
            name: "hello world",
            doubleValue: 15, url: "http://www.naver.com",
            userIds: [1, 2, 3, 4, 5],
            value: 245,
            isSecret: true)
        let blog02 = createBlog(
            name: "hello world",
            doubleValue: 15, url: "http://www.naver.com",
            userIds: [1, 2, 3, 4, 5],
            value: 245,
            isSecret: true)
        user.blogArray = [blog01, blog02]
        
        let human = try? runtimeMapper.readObject(from: user, initializer: Human.init)
        XCTAssertNotNil(human, "human should be not nil")
        
        XCTAssertEqual(human?.age, 123)
        XCTAssertEqual(human?.name, "Ahn DeockHwan")
        
        XCTAssertNotNil(human?.blog, "human's blog should be not nil")
        
        XCTAssertEqual(human?.blog?.id, 20)
        XCTAssertEqual(human?.blog?.isSecret, true)
        XCTAssertEqual(human?.blog?.doubleValue, 15)
        XCTAssertEqual(human?.blog?.name, "hello world")
        XCTAssertEqual(human?.blog?.url, "http://www.naver.com")
        XCTAssertEqual(human?.blog?.userIds, [1, 2, 3, 4, 5])
        XCTAssertEqual(human?.blog?.value, 245)
    }
}
