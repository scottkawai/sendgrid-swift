import Foundation
#if os(Linux)
import FoundationNetworking
#endif

public extension Session {
    /// :nodoc:
    @available(*, deprecated, renamed: "send(request:completionHandler:)")
    func send<ModelType: Decodable>(modeledRequest request: ModeledRequest, completionHandler: ((Result<(HTTPURLResponse, ModelType), Error>) -> Void)? = nil) throws {}
}
