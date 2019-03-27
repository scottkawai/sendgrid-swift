import Foundation

public extension ContentType {
    /// :nodoc:
    @available(*, deprecated, renamed: "init(rawValue:)")
    static func other(_ rawValue: String) -> ContentType { return ContentType(rawValue: rawValue)! }
}
