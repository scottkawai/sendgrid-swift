import Foundation

public extension RateLimit {
    /// :nodoc:
    @available(*, deprecated, renamed: "from(response:)")
    static func rateLimitInfo(from response: URLResponse?) -> RateLimit? { return RateLimit.from(response: response) }
}
