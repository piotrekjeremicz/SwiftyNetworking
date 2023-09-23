import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(NetworkingMacros)
import NetworkingMacros

let testMacros: [String: Macro.Type] = [
    "Request": RequestMacro.self,
]
#endif

final class NetworkingMacroTests: XCTestCase {
    func testMacro() throws {
        #if canImport(NetworkingMacros)
        assertMacroExpansion(
            """
            @Request
            struct GetExampleRequest: Request {
            
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
            struct GetExampleRequest: Request {
                
                typealias ResponseBody = Empty
                typealias ResponseError = Empty
            
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
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }

}
