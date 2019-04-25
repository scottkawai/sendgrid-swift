import Foundation

enum Exception: Error, CustomStringConvertible {
    case encodedDataIsNilString
    var description: String {
        switch self {
        case .encodedDataIsNilString:
            return "The encoded object could not be represented as a `String`."
        }
    }
}
