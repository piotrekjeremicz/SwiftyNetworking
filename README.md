# SwiftyNetworking
## Overview

**SwiftyNetworking** is a lightweight and expressive framework for building networking layers in Swift applications.  
Its core idea is inspired by **SwiftUI’s declarative design**, where views are composed using modifiers - here, requests are built in exactly the same way.

## Features

- 🧩 Declarative request composition inspired by **SwiftUI**
- 🔒 Strong **type-safety** with compile-time request/response matching
- 🧠 `@Request` macro that reduces boilerplate
- ⚙️ Built-in **modifiers system**
- 💾 Environment-like **Configuration** propagation
- 🧰 Fully **Sendable** and compliant with Swift 6 concurrency rules
- 🧪 Ready for upcoming test and mocking utilities


### Project Status

_Version **0.9** introduces a **major refactor** that finalizes the architecture of the package.
The structure of types, modifiers, and core abstractions is now stable and will not change significantly.
Before version **1.0**, the focus will be on adding tests, and performing a full validation pass for stability and correctness._

_The first public release (v1.0) is planned at the **end of this year**._


## Quick Start
_Assuming default isolation set to `MainActor`_

1. **Create a service** that defines your API endpoint.
```swift
struct ExampleService: Service {
    let baseURL: String = "https://www.example.com"
}
```


2.	Define models for your response and error payloads.
```swift
nonisolated struct ExampleResponseModel: Codable {
    let foo: String
    let bar: Int
    let buzz: Bool
}

nonisolated struct ExampleErrorModel: Codable {
    let status: Int
    let message: String
}
```


3.	Describe your request using the @Request macro.
```swift
@Request
struct ExampleRequest {
    let bar: String
    
    var body: some Request {
        Get("foo", bar, "buzz", from: ExampleService())
            .headers {
                ApiKey(value: "sample_token")
            }
            .queryItems {
                Key("hello", value: "world")
            }
            .body(.json) {
                Key("array") {
                    Key("int", value: 42)
                    Key("double", value: 3.14)
                    Key("bool", value: true)
                    Key("string", value: "foo")
                    Key("array", value: ["foo", "bar", "buzz"])
                }
            }
            .responseBody(ExampleResponseModel.self)
            .responseError(ExampleErrorModel.self)
        }
    }
}
```


4.	Send the request using a session - and cancel it anytime if needed. 😉
```swift
let session = Session()
let exampleRequest = ExampleRequest(bar: "buzz")
let (result, error) = await session.send(request: exampleRequest)

if somethingIsWrong {
    session.cancel(requests: .every(ExampleRequest.self))
}
```

And that’s it - your first request is live! 🚀

## Architecture

The Request protocol defines how a final URLRequest is constructed through a chain of modifiers, each returning a ModifiedRequest that carries configuration and transformation logic. This declarative design mirrors SwiftUI’s View and Environment, enabling clear and composable networking layers powered by a shared Configuration store. SwiftyNetworking emphasizes type safety, allowing developers to precisely define response models, while the @Request macro eliminates boilerplate and keeps the API concise and expressive - all built fully in line with Swift 6 concurrency rules.

### Template

We love optimizing our workflow!

That’s why I've' prepared a **template** for creating basic `Request` implementations - and, honestly, discovering the token menu made it even more fun! 😄

If you like this approach, don’t forget to give it a ⭐️ on GitHub!
![Request template](/Docs/Images/request_template.png)
You can easily install the template by running the `install.sh` script located in the `Templates` directory.

## Advanced usage

### Authentication & Authorization

In most cases, you’ll need to send authorized requests. SwiftyNetworking makes it simple to handle tokens and credentials through the **AuthorizationProvider** system.

#### 1. Create your own Authorization Provider

To handle authorization, implement the `AuthorizationProvider` protocol. You can use the built-in `KeychainAuthorizationStore` provided by the package, or create your own `AuthorizationStore`. The `authorize` method defines how to configure a request before it’s sent.

```swift
struct ExampleAuthorizationProvider: AuthorizationProvider {
    let store: any AuthorizationStore = KeychainAuthorizationStore()
    
    func authorize(_ request: any Request) -> any Request {
        if let accessToken = store.get(.accessToken) {
            request.headers {
                Authorization(bearer: accessToken)
            }
        } else {
            request
        }
    }
}
```

#### 2. Assign the provider to your Service

Once your provider is ready, assign it to the corresponding Service. Every request sent through this service will automatically use the configured provider.

```swift
struct ExampleService: Service {
    [...]
    
    var authorizationProvider: (any AuthorizationProvider)? = ExampleAuthorizationProvider()
}
```

#### 3. Store and reuse credentials

When a request returns credentials (for example, after login), use the storeCredentials modifier to persist them securely. Requests that require authentication can then use the authorize() modifier to attach stored credentials automatically.

```swift
@Request
struct LoginRequest {
    let username: String
    let password: String
    
    var body: some Request {
        Post("auth", "login", from: ExampleService())
            .responseBody(AuthorizedUser.self)
            .storeCredentials { authorizedUser, store in
                store.set(.accessToken, value: authorizedUser.accessToken)
            }
    }
}

@Request
struct AuthRequest {
    var body: some Request {
        Get("auth", "me", from: ExampleService())
            .responseBody(User.self)
            .authorize()
    }
}
```

This approach cleanly separates authorization logic from request definition, allowing you to reuse providers across multiple services while maintaining a fully declarative and type-safe networking layer.


### Interceptors
When working with a network layer, we often need to execute actions right before sending a request or right after receiving a response - for example, adding an authorization token or logging a request.

**SwiftyNetworking** provides simple hooks that let you intercept and modify both the request and the response.

```swift
extension ExampleService {
    var beforeEachRequest: RequestInterceptorClosure? = { request in
        print("before each request: \(request.debugDescription)")
        return request
    }
    
    var afterEachResponse: ResponseInterceptorClosure? = { response, request in
        print("after each response from request: \(request.debugDescription)")
        return response
    }
}
```

### Logger
The logger in SwiftyNetworking is fully optional.

By providing any custom-configured Logger, network-related events will be automatically logged - including requests, responses, and errors.

```swift
struct ExampleService: Service {
    let baseURL: String = "https://dummyjson.com"
    let logger: Logger? = Logger(subsystem: "com.example.app", category: "networking")
}
```

## What's next?
Currently, my full focus is on finishing the package and releasing version 1.0.

Looking ahead, I plan to rethink and extend the development roadmap, considering features such as:
- Mocking data for testing and prototyping,
- Networking previews in Xcode,
- Enhanced request configuration options to provide more flexibility for developers.

These improvements aim to make SwiftyNetworking even more powerful and developer-friendly in future versions.

⸻

