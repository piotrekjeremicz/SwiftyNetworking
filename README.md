# SwiftyNetworking
## Overview
Swifty Networking is a simple package that supports the networking layer and provide, similar to SwiftUI, request building pattern.

## How to use it?
1. Create service that provides relevant API
```swift
struct ExampleService: Service {
    var baseURL: URL { URL(string: “https://www.example.com”)! }
}
```

2. Prepare models for **data** and **error** responses
```swift
struct ExampleResponseModel: Decodable {
    let name: String
    let age: Int
    let isUser: Bool
}

struct ExampleErrorModel: Decodable {
    let status: Int
    let message: String
}
```

3. Describe request by using `Request` abstraction
```swift
struct ExampleRequest: Request {
    typealias Response = ExampleResponseModel
    typealias ResponseError = ExampleErrorModel
    
    var request: some Request {
        Get(“/example”, from: ExampleService())
            .headers([
                “Authorization”: “Example”
            ])
            .queryItems([
                URLQueryItem(name: “hello”, value: “world”)
            ])
            .body(String(“SwiftyNetworking!”))
    }
}
```

4. Create `session` and send request
```swift
let session = Session()

Task {
    do {
        let result = try await session.trySend(request: ExampleRequest())
    } catch {
        print(error)
    }
}
```

And that’s it!

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
            Get(“/example/1”, from: ExampleService())
            Get(“/example/2”, from: ExampleService())
            Get(“/example/3”, from: ExampleService())
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

### Improving response associated types
### More modifiers, more settings!
