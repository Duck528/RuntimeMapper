## RuntimeMapper

RuntimeMapper is a Swift library to dynamic mapping with json or class. this library using [Runtime](https://github.com/wickwirew/Runtime) to dynamically setting a property. this library for now under development.

#### How to use 
- Define Model Class
```swift
    class Blog {
        var id: Int = 0
        var url: String = ""
        var name: String = ""
        var value: Float = 0
        var isSecret: Bool = true
    }
```

- Single Json
```swift

    
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
    
    let runtimeMapper = RuntimeMapper()
    if let blog = try? runtimeMapper.readSingle(from: jsonSigleString, initializer: Blog.init) {
        print("id: \(blog.id)")
        print("url \(blog.url)")
        print("name: \(blog.name)")
        print("value: \(blog.value)")
        print("isSecret: \(blog.isSecret)")
    }
```

- Array Json 
```swift
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
    
    if let blogs = try? runtimeMapper.readArray(from: jsonArrayString, initializer: Blog.init) {
        blogs.forEach {
            print("id: \($0.id)")
            print("url \($0.url)")
            print("name: \($0.name)")
            print("value: \($0.value)")
            print("isSecret: \($0.isSecret)")
        }
    }
```

- Nested Json 
```swift
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
        },
        "blogArray": [{
            "id": 111,
            "url": "http://roadfiresoftware.com/blog/",
            "name": "Roadfire Software Blog",
            "value": 1231.11,
            "doubleValue": 123213.12322,
            "isSecret": false
        },
        {
            "id": 111,
            "url": "http://roadfiresoftware.com/blog/",
            "name": "article blog",
            "value": 1231.11,
            "doubleValue": 123213.12322,
            "isSecret": false
        }]
    }
    """
    
    let runtimeMapper = RuntimeMapper()
    runtimeMapper.register(key: "blog", classType: Blog.self, parseType: .single)
    runtimeMapper.register(key: "blogArray", classType: Blog.self, parseType: .array)
    if let user = try? runtimeMapper.readSingle(from: jsonNestedString, initializer: User.init) {
        print("name: \(user.name)")
        print("age: \(user.age)")
        print("blog name: \(user.blog.name)")
        print("blog id: \(user.blog.id ?? -1)")
        user.blogArray.forEach {
            print("[array] name: \($0.name)")
        }
    }
```
