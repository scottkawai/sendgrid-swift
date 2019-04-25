import Foundation

public extension Authentication {
    /// :nodoc:
    @available(*, unavailable, message: "use the designated initializer or one of the static functions")
    init?(info: [AnyHashable: Any]) { return nil }

    /// :nodoc:
    @available(*, unavailable, message: "use the `value` property to extrapolate the desired value")
    var user: String? { return nil }

    /// :nodoc:
    @available(*, unavailable, message: "use the `value` property to extrapolate the desired value")
    var key: String { return "" }
}
