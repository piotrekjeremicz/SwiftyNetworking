# SwiftyNetworking
Keep in mind - this package is in the process of **hard* development! 👨🏻‍💻 🚀

## Overview
Swifty Networking is a simple package that supports the networking layer and provide, similar to SwiftUI ViewBuilder, request building pattern.

The package is under heavy development. The structure of types and methods seems to be final, but over time there may be some changes resulting from the need to implement a new function. Version 0.5 is halfway to the first public stable version. Before this happens, I have to implement a few points according to the roadmap at the bottom.

## How to use it?
1. Create service that provides relevant API.
```swift
struct ExampleService: Service {
    var baseURL: URL { URL(string: "https://www.example.com")! }
}
```

2. Prepare models for **data** and **error** responses.
```swift
struct ExampleResponseModel: Codable {
    let foo: String
    let bar: Int
    let buzz: Bool
}

struct ExampleErrorModel: Codable {
    let status: Int
    let message: String
}
```

3. Describe request by using `Request` abstraction.
```swift
struct ExampleRequest: Request {
    let bar: String
    
    var body: some Request {
        Get("foo", bar, "buzz", from: ExampleService())
            .headers {
                Authorization("sample_token")
            }
            .queryItems {
                Key("hello", value: "world")
            }
            .body {
                Key("array") {
                Key("int", value: 42)
                Key("double", value: 3.14)
                Key("bool", value: true)
                Key("string", value: "foo")
                Key("array", value: ["foo", "bar", "buzz"])
            }
            .responseBody(ExampleResponseModel.self)
            .responseError(ExampleErrorModel.self)
        }
    }
}
```

4. Create `session` and send request. Of course, you can cancel it as you want. 😉
```swift
let session = Session()
let (result, error) = await session.send(request: ExampleRequest(bar: "buzz"))

if sometingIsWrong {
    session.cancel(requests: .only(request.id))
}
```

And that’s it!

## Advanced usage
### Authorization
**SwiftyNetworking** provides easy to use and elastic authorization model. Assuming that most authorizations consist in obtaining a token from one request and using it in the others, this package contains a simple system that allows you to catch and use such values.

1. Implement additional methods in **Service**.
```swift
struct ExampleService: Service {
    [...]
    
    func authorize<R>(_ request: R) -> R where R : Request {
        request
            .headers {
                Authorization("BASIC secret_token")
            }
    }
}
```

2. Capture credentials from the appropriate query.
```swift
//TODO: Sample code
```

3. Add `authorize()` modifier to each request that requires authorization.
```swift
struct ExampleAuthorizedRequest: Request {    
    var body: some Request {
        Get("foo", bar, "buzz", from: ExampleService())
            [...]
            .authorize()
        }
    }
}
```

## What’s next?
There are a few more things I want to add and support::

### Mocking data
```swift
// Dummy code
request
    .mocked(where: { response in
        switch response {
        case successed:
            //do something
        case failed:
            //do something
        }
    })
```

### Queueing requests
```swift
// Dummy code
struct ExampleRequest: Request {
    typealias Response = ExampleResponseModel
    typealias ResponseError = ExampleErrorModel
    
    var request: some Request {
        Queue {
            Get("/example/1", from: ExampleService())
            Get("/example/2", from: ExampleService())
            Get("/example/3", from: ExampleService())
        }
    }
}
```

### Supporting curl strings
```swift
// Dummy code
struct ExampleRequest: Request {
    typealias Response = ExampleResponseModel
    typealias ResponseError = ExampleErrorModel
    
    var request: some Request {
        "curl -X POST https://www.example/login/ -d 'username=example&password=examle'"
    }
}
```

More modifiers, more settings!

## Roadmap
- **Version 0.6:** finish `Authorization` layer
- **Version 0.7:** add `before`, `after` and `beforeEach`, `afterEach` modifiers to provide basic middleware support
- **Version 0.8:** add `Mock` result that will be an alternative output for `Request`
- **Version 0.9:** refactor, unit tests and whatever else that will be needed to be proud of this package 😇