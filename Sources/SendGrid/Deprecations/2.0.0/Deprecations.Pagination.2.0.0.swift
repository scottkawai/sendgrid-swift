import Foundation
#if os(Linux)
import FoundationNetworking
#endif

public extension Pagination {
    /// :nodoc:
    @available(*, deprecated, renamed: "init(response:)")
    static func from(response: URLResponse?) -> Pagination? { nil }
}
