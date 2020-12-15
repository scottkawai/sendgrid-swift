import Foundation
#if os(Linux)
import FoundationNetworking
#endif

public extension Session {
    /// :nodoc:
    @available(*, deprecated, renamed: "send(request:completionHandler:)")
    func send<Payload: Request>(modeledRequest request: Payload, completionHandler: ((Result<(HTTPURLResponse, Payload.ResponseType), Error>) -> Void)? = nil) throws {}
}
