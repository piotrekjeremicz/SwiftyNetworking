//
//  ResponseBuilder.swift
//  
//
//  Created by Piotrek Jeremicz on 12/05/2023.
//

import Foundation

public struct ResponseBuilder<Body: Codable> {
    typealias Body = Body
    
    let afterAuthorization: ((_ response: Body, _ store: AuthorizationStore) -> Void)?
    
    public init(afterAuthorization: ((_ response: Body, _ store: AuthorizationStore) -> Void)? = nil) {
        self.afterAuthorization = afterAuthorization
    }
    
    func resolve<R: Request>(result: (data: Data, response: URLResponse), request: R) throws -> Response<Body> {
        let response = try Response<Body>(result, from: request)
        
        if let store = request.configuration?.service.authorizationProvider?.store {
            request.builder.afterAuthorization?(response.body as! R.ResponseBody, store)
        }
        
        return response
    }
}
