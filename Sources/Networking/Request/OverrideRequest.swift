//
//  OverrideRequest.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 25.09.2025.
//

struct OverrideRequest<Content, ResponseBody: Codable, ResponseError: Codable>: Request where Content: Request {
    let content: Content
    var configuration: ConfigurationValues?
    
    init(
        content: Content,
        configuration: ConfigurationValues
    ) {
        self.content = content
        self.configuration = configuration
    }
    
    var body: some Request {
        content
    }
}
