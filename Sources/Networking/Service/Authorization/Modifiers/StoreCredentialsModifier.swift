//
//  StoreCredentialsModifier.swift
//  SwiftyNetworking
//
//  Created by Piotrek Jeremicz on 12.10.2025.
//

public extension Request {
    func storeCredentials(responseModel: @escaping @Sendable (Self.ResponseBody, any AuthorizationStore) -> Void) -> some Request {
        afterResponse { response, _ in
            if let model = response.body.value as? Self.ResponseBody, let store = resolveConfiguration().service?.authorizationProvider?.store {
                responseModel(model, store)
            }
            
            return response
        }
    }
}
