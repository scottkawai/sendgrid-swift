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
    public var endpoint: URLComponents? { return nil }
    
    /// :nodoc:
    @available(*, deprecated, message: "use the new methods in `Session` to faciliate building the URL request.")
    public func generateUrlRequest() throws -> URLRequest {
        throw Exception.Request.couldNotConstructUrlRequest
    }
    
    /// :nodoc:
    @available(*, deprecated, message: "use the `headers` property to set any headers on the request.")
    public var contentType: ContentType { return .json }
    
    /// :nodoc:
    @available(*, deprecated, message: "use the `headers` property to set any headers on the request.")
    public var acceptType: ContentType { return .json }
}
