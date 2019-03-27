//
//  Deprecations.Request.2.0.0.swift
//  SendGrid
//
//  Created by Scott Kawai on 6/20/18.
//

import Foundation

public extension Request {
    /// :nodoc:
    @available(*, deprecated, renamed: "endpointPath")
    var endpoint: URLComponents? { return nil }
    
    /// :nodoc:
    @available(*, deprecated, message: "use the new methods in `Session` to faciliate building the URL request.")
    func generateUrlRequest() throws -> URLRequest {
        throw Exception.Request.couldNotConstructUrlRequest
    }
    
    /// :nodoc:
    @available(*, deprecated, message: "use the `headers` property to set any headers on the request.")
    var contentType: ContentType { return .json }
    
    /// :nodoc:
    @available(*, deprecated, message: "use the `headers` property to set any headers on the request.")
    var acceptType: ContentType { return .json }
}
