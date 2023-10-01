# SwiftyNetworking
Keep in mind - this package is in the process of **heavy** development! 👨🏻‍💻 🚀

## Overview
Swifty Networking is a simple package that supports the networking layer and provide, similar to SwiftUI's ViewBuilder, request building pattern.

**Note:**
*The package is under heavy development. The structure of types and methods seems to be final, but over time there may be some changes resulting from the need to implement a new function. Version 0.5 is halfway to the first public stable version. Before this happens, I have to implement a few points according to the roadmap at the bottom.*

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


3. Describe request by using `Request` macro.
```swift
@Request
struct ExampleRequest {

    let bar: String
    
    var body: some Request {
        Get("foo", bar, "buzz", from: ExampleService())
            .headers {
                X_Api_Key(value: "sample_token")
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

1. Create a new inheritance structure from `AuthorizationService`. There are two variables and one method that are needed to store sensitive data. The most important part is `func authorize<R: Request>(_ request: R) -> R` which is a place where you can inject token from the store.
```swift
struct BackendAuthorization: AuthorizationProvider {

    var store: AuthorizationStore = BackendAuthorizationStore()
    var afterAuthorization: ((Codable, AuthorizationStore) -> Void)? = nil
        
    func authorize<R: Request>(_ request: R) -> R {
        if let token = store.get(key: .token) {
            return request.headers {
                Authorization(.bearer(token: token))
            }
        } else {
            return request
        }
    }
}
```

2. You can use default `KeychainAuthorizationStore` or create a new inheritance structure from `AuthorizationStore`.
```swift
struct BackendAuthorizationStore: AuthorizationStore {
    let keychain = Keychain(service: "com.example.app")
    
    static var tokenKey: String { "com.example.app.token" }
    static var refreshTokenKey: String { "com.example.app.refresh-token" }
    static var usernameKey: String { "com.example.app.username" }
    static var passwordKey: String { "com.example.app.password" }
    
    //I would like to make it better
    func store(key: AuthorizationKey, value: String) {
        try? keychain.set(value, key: key.representant(for: Self.self))
    }
    
    func get(key: AuthorizationKey) -> String? {
        try? keychain.get(key.representant(for: Self.self))
    }
}
```
3. We are ready to catch our credentials. In this case, it will be a token that the server returns after authentication process.
```swift
@Request
struct ExampleLoginRequest {    
    var body: some Request {
        Get("login", from: ExampleService())
            //[...]
            .responseBody(LoginResponse.self)
            .afterAutorization { response, store in
                store.value(.token(response.token))
            }
        }
  
```

4. Add `authorize()` modifier to each request that requires authorization.
```swift
@Request
struct ExampleAuthorizedRequest {    
    var body: some Request {
        Get("foo", bar, "buzz", from: ExampleService())
            //[...]
            .authorize()
        }
    }
}
```

And that is it!

### Middleware
Working with the network layer, we very often perform repetitive actions such as adding the appropriate authorization header or want to save the effect of the request sent. **SwiftyNetworking** allows you to perform actions just before completing the query and just after receiving a response.
```swift
struct ExampleService: Service {

    //[...]
    
    func beforeEach<R>(_ request: R) -> R where R: Request {
        request
            .headers {
                X_Api_Key(value: "secret_token")
            }
    }

    func afterEach<B>(_ response: Response<B>) -> Response<B> where B: Codable {
        statistics.store(response.statusCode)
    }
}
```

### Logger
**SwiftyNetworking** provides default OSLog entity. You can use your own Logger object.
```swift
import OSLog

struct ExampleService: Service {
    //[...]
    
    let logger = Logger(subsystem: "com.example.app", category: "networking")
}
```

## Roadmap
- **Version 0.9:** add `Mock` result that will be an alternative output for `Request`
- **Version 1.0:** refactor, unit tests and whatever else that will be needed to be proud of this package 😇

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
@Request
struct ExampleRequest {
    var body: some Request {
        Queue {
            Get("/example/1", from: ExampleService())
            Get("/example/2", from: ExampleService())
            Get("/example/3", from: ExampleService())
        }
    }
}
```

### Networking preview
```swift
// Dummy code
@Request
struct ExampleRequest {
    var body: some Request { }
}

#NetworkingPreview {
    ExampleRequest()
}

```

### Supporting curl strings
```swift
// Dummy code
@Request
struct ExampleRequest {
    typealias Response = ExampleResponseModel
    typealias ResponseError = ExampleErrorModel
    
    var request: some Request { }
}
```

More modifiers, more settings!
