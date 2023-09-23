import Foundation
import Networking
import NetworkingMacro

struct BackendService: Service {
    var baseURL: URL { return URL(string: "https://example.com")! }
}

struct ResponseBody: Codable {
    let body: String
}

struct ResponseError: Codable {
    let error: String
}

@Request struct GetExampleRequest: Request {
    var body: some Request {
        Post("foo", "bar", from: BackendService())
            .authorize()
            .headers {
                Key("Test", value: "Abc")
            }
            .headers({
                Key("ABC", value: "123")
            })
            .responseBody(ResponseBody.self)
            .responseError(ResponseError.self)
    }    
}

let test = GetExampleRequest()
