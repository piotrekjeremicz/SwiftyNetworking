//
//  main.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 20.09.2025.
//

import Networking

struct ExampleService: Service {
    var baseURL: String = "https://example.com"
}

struct SampleModel: Codable {
    let foo: String
}

struct SampleError: Codable {
    let test: String
}

@Request
struct SampleRequest {
    let postId: Int
    let message: String

    var body: some Request {
        Post("posts", postId, "comment", from: ExampleService())
            .headers {
                Accept.json
                CacheControl.maxAge(60)
            }
            .queryItems {
                Key("flag", value: true)
            }
            .body(.json) {
                Key("message", value: message)
            }
            .responseBody(SampleModel.self)
            .responseError(SampleError.self)
    }
}

let sampleRequest = SampleRequest(postId: 41, message: "Hello, world!")

let session = Session()
Task {
    let response = try! await session.trySend(sampleRequest)
    print(response.foo)
}

Task {
    print(sampleRequest.debugDescription)
}

@Request
struct SampleBodyRequest {
    var body: some Request {
        Post("article", from: ExampleService())
            .body(encoding: .utf8, "{\"title\": \"Hello, world!\"}")
            .headers(override: true) {
                ContentType.json
            }
    }
}



let sampleBodyRequest = SampleBodyRequest()
