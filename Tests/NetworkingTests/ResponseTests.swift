//
//  ResponseTests.swift
//  SwiftyNetworking
//

import Foundation
import Testing
@testable import Networking

private struct MockService: Service {
    let baseURL: String = "https://example.com"
}

private struct DTO: Codable, Equatable {
    let name: String
}

private func makeResult(data: Data) -> (data: Data, response: URLResponse) {
    let response = HTTPURLResponse(
        url: URL(string: "https://example.com")!,
        statusCode: 200,
        httpVersion: nil,
        headerFields: nil
    )!
    return (data, response)
}

@Test func responseBodyDataPassesThroughRawBytesWithoutDecoding() throws {
    // Arbitrary bytes that are not valid JSON, which would fail `JSONDecoder`.
    let rawBytes = Data([0xDE, 0xAD, 0xBE, 0xEF, 0x00, 0xFF, 0x10])
    let configuration = ConfigurationValues()

    let response = try Response<Data>(makeResult(data: rawBytes), from: configuration)

    #expect(response.body == rawBytes)
}

@Test func responseBodyCodableStillDecodesNormally() throws {
    let dto = DTO(name: "piotrek")
    let data = try JSONEncoder().encode(dto)
    let configuration = ConfigurationValues()
    configuration.service = MockService()

    let response = try Response<DTO>(makeResult(data: data), from: configuration)

    #expect(response.body == dto)
}
