## RuntimeMapper

RuntimeMapper is a Swift library to dynamic mapping with json or class. this library using [Runtime](https://github.com/wickwirew/Runtime) to dynamically setting a property. this library for now under development.

#### How to use 
- Single Json
```swift
    class Blog {
        var id: Int = 0
        var url: String = ""
        var name: String = ""
        var value: Float = 0
        var isSecret: Bool = true
    }
    
    let jsonSigleString =
    """
    {
        "id": 111,
        "url": "http://roadfiresoftware.com/blog/",
        "name": "Roadfire Software Blog",
        "value": 1231.11,
        "isSecret": false
    }
    
    let runtimeMapper = RuntimeMapper()
    if let blog = try? runtimeMapper.readSingle(from: jsonSigleString, initializer: Blog.init) {
        print("id: \(blog.id)")
        print("url \(blog.url)")
        print("name: \(blog.name)")
        print("value: \(blog.value)")
        print("isSecret: \(blog.isSecret)")
    }
    """
```

- Array Json 
```swift
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
