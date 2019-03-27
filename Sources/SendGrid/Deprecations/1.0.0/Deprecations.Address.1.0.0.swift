import Foundation

public extension Address {
    /// :nodoc:
    @available(*, deprecated, renamed: "init(email:)")
    init(_ email: String) { self.init(email: email, name: nil) }
}
