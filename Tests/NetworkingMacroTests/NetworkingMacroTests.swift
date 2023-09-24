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
                let service: BackendService
            
                var body: some Request {
                    Post("foo", "bar", id, from: service)
                        .responseBody(ResponseBody.self)
                        .responseError(ResponseError.self)
                        .responseBody(AnotherResponseBody.self)
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
    //            .responseBody(ResponseBody.self)
                .responseError(ResponseError.self)
                .responseBody(AnotherResponseBody.self)
        }
    }
    """,
    expandedSource: """
    struct GetExampleRequest {
        let id: String
        let service: BackendService
    
        var body: some Request {
            Post("foo", "bar", id, from: service)
    //            .responseBody(ResponseBody.self)
                .responseError(ResponseError.self)
                .responseBody(AnotherResponseBody.self)
        }
    
        typealias ResponseBody = Empty
    
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
}
