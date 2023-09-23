import Foundation
import Networking
import NetworkingMacro

struct BackendService: Service {
    var baseURL: URL { return URL(string: "https://example.com")! }
}

struct SampleBody: Codable {
    let body: String
}

struct SampleError: Codable {
    let error: String
}

@Request struct GetExampleRequest {
    let service: BackendService
    
    var body: some Request {
        Post("foo", "bar", from: service)
            .authorize()
            .headers {
                Key("Test", value: "Abc")
            }
            .headers({
                Key("ABC", value: "123")
            })
            .responseBody(SampleBody.self)
            .responseError(SampleError.self)
    }    
}

let test = GetExampleRequest(service: BackendService())
