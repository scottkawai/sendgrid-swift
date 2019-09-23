import Foundation
#if os(Linux)
import FoundationNetworking
#endif

public extension ModeledRequest {
    /// :nodoc:
    @available(*, deprecated, renamed: "endpointPath")
    var endpoint: URLComponents? { nil }
    
    /// :nodoc:
    @available(*, deprecated, message: "use the new methods in `Session` to faciliate building the URL request.")
    func generateUrlRequest() throws -> URLRequest {
        throw Exception.Request.couldNotConstructUrlRequest
    }
    
    /// :nodoc:
    @available(*, deprecated, message: "use the `headers` property to set any headers on the request.")
    var contentType: ContentType { .json }
    
    /// :nodoc:
    @available(*, deprecated, message: "use the `headers` property to set any headers on the request.")
    var acceptType: ContentType { .json }
}
