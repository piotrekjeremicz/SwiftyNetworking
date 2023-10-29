import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

#if canImport(NetworkingMacros)
import NetworkingMacros

let testMacros: [String: Macro.Type] = [
    "Request": RequestMacro.self,
]
#endif

final class NetworkingMacroTests: XCTestCase {
    func testBaseRequest() throws {
#if canImport(NetworkingMacros)
        assertMacroExpansion(
            """
            @Request
            struct GetExampleRequest {
                let id: String
                let login: String
                let password: String
                let service: BackendService
            
                var body: some Request {
                    Post("foo", "bar", id, from: service)
                        .headers {
                            X_Api_Key(value: "secret_token")
                        }
                        .queryItems{
                            Key("login", value: login)
                            Key("password", value: password)
                        }
                        .authorize()
                        .responseBody(ResponseBody.self)
                        .responseError(ResponseError.self)
                        .responseBody(AnotherResponseBody.self)
                }
            }
            """,
            expandedSource: """
            struct GetExampleRequest {
                let id: String
                let login: String
                let password: String
                let service: BackendService
            
                var body: some Request {
                    Post("foo", "bar", id, from: service)
                        .headers {
                            X_Api_Key(value: "secret_token")
                        }
                        .queryItems{
                            Key("login", value: login)
                            Key("password", value: password)
                        }
                        .authorize()
                        .responseBody(ResponseBody.self)
                        .responseError(ResponseError.self)
                        .responseBody(AnotherResponseBody.self)
                }
            
                typealias ResponseBody = AnotherResponseBody
            
                typealias ResponseError = ResponseError
            }
            
            extension GetExampleRequest: Request {
            }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }
    
    func testRequestWithComment() throws {
#if canImport(NetworkingMacros)
        assertMacroExpansion(
    """
    @Request
    struct GetExampleRequest {
        let id: String
        let service: BackendService
    
        var body: some Request {
            Post("foo", "bar", id, from: service)
                .responseBody(ResponseBody.self)
                .responseError(ResponseError.self)
    //          .responseBody(AnotherResponseBody.self)
        }
    }
    """,
    expandedSource: """
    struct GetExampleRequest {
        let id: String
        let service: BackendService
    
        var body: some Request {
            Post("foo", "bar", id, from: service)
                .responseBody(ResponseBody.self)
                .responseError(ResponseError.self)
    //          .responseBody(AnotherResponseBody.self)
        }
    
        typealias ResponseBody = ResponseBody

        typealias ResponseError = ResponseError
    }
    
    extension GetExampleRequest: Request {
    }
    """,
    macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }
    
    func testRequestWithResponseBodyArray() throws {
#if canImport(NetworkingMacros)
        assertMacroExpansion(
    """
    @Request
    struct SourcesRequest {

        let page: Int
        let service: Service
        
        var body: some Request {
            Get("v1", "sources", from: service)
                .authorize()
                .queryItems {
                    Key("page", value: page)
                }
                .responseBody([Source].self)
                .responseError(BackendErrorResponse.self)
        }
    }
    """,
    expandedSource: """
    struct SourcesRequest {

        let page: Int
        let service: Service
        
        var body: some Request {
            Get("v1", "sources", from: service)
                .authorize()
                .queryItems {
                    Key("page", value: page)
                }
                .responseBody([Source].self)
                .responseError(BackendErrorResponse.self)
        }
    
        typealias ResponseBody = [Source]

        typealias ResponseError = BackendErrorResponse
    }
    
    extension SourcesRequest: Request {
    }
    """,
    macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }
}
