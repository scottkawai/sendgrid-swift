import Foundation

public extension Exception {
    /// The `Exception.Global` struct contains global errors that can be thrown.
    enum Global: Error, CustomStringConvertible {
        // MARK: - Cases
        
        /// Thrown in the event an old, deprecated method is called.
        case methodUnavailable(AnyClass, String)
        
        /// Thrown if a `limit` property has an out-of-range value.
        case limitOutOfRange(Int, CountableClosedRange<Int>)
        
        // MARK: - Properties
        
        /// A description for the error.
        public var description: String {
            switch self {
            case .methodUnavailable(let klass, let methodName):
                return "The `\(methodName)` method on \(klass) is no longer available."
            case .limitOutOfRange(let value, let range):
                return "The `limit` value must be between \(range.lowerBound) and \(range.upperBound) (inclusive). You specified \(value)."
            }
        }
    }
}
