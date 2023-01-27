//
//  SwiftUIView.swift
//  
//
//  Created by Piotrek on 18/06/2022.
//

import Foundation

struct ExampleService: Service {
    var baseURL: URL { URL(string: "https://www.example.com")! }
}

struct ExampleResponseModel: Codable {
    let name: String
    let age: Int
    let isUser: Bool
}

struct ExampleErrorModel: Codable {
    let status: Int
    let message: String
}

struct ExampleRequest: Request {
    typealias ResponseBody = ExampleResponseModel
    typealias ResponseError = ExampleErrorModel

    var body: some Request {
        Get("path", "to", "endpoint", from: ExampleService())
            .headers {
                Authorization("Example")
            }
            .queryItems {
                Key("hello", value: "world")
            }
            .body(String("SwiftyNetworking!"))
    }
}

struct TestService: Service {
    var baseURL: URL { URL(string: "https://example.com")! }
}

struct TestResponse: Codable {
    let text: String
}

struct TestError: Codable {
    let text: String
}

struct GetArticlesRequest: Request {
    typealias ResponseBody = TestResponse
    typealias ResponseError = TestError
    
    var body: some Request {
        Get("/articles", from: TestService())
            .headers {
                Authorization("Sample")
            }
            .queryItems {
                Key("Test", value: "test")
            }
            .body(String("Test"))
            .mocked { request in
                Mock.Case()
            }
//            .mocked { request in
//                    .success(when: request.body != nil) {
//                        .response(200, data: Data())
//                    }
//                    .failure(when: request.body == nil) {
//                        .response(400, error: ExampleErrorModel(status: 400, message: "test"))
//                    }
//            }
    }
}

struct GetArticlesSummaryRequest: Request {
    typealias ResponseBody = TestResponse
    typealias ResponseError = TestError
    
    var body: some Request {
        GetArticlesRequest()
    }
}

let request = try? GetArticlesRequest().urlRequest()

//struct ExampleRequest: Request {
//    typealias Response = ExampleResponseModel
//    typealias ResponseError = ExampleErrorModel
//    
//    var request: some Request {
//        Queue {
//            Get("/example/1", from: ExampleService())
//            Get("/example/2", from: ExampleService())
//            Get("/example/3", from: ExampleService())
//        }
//    }
//}
