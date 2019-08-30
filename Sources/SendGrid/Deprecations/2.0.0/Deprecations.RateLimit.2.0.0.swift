import Foundation

public extension RateLimit {
    /// :nodoc:
    @available(*, deprecated, renamed: "init(response:)")
    static func from(response: URLResponse?) -> RateLimit? { nil }
}
