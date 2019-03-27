import Foundation

public extension Request {
    /// :nodoc:
    @available(*, unavailable, message: "use the `generateUrlRequest` method instead.")
    func request(for session: Session, onBehalfOf: String?) throws -> URLRequest {
        throw Exception.Global.methodUnavailable(type(of: self), "request(for:onBehalfOf:)")
    }
}
