import Foundation

/// The `ResponseRepresentable` protocol is used by types that represent a model
/// returned from an API call.
///
/// If you define a model that should be converted from JSON upon an API return,
/// you'll want to ensure that it conforms to the `ResponseRepresentable` 
/// protocol. Doing so is how `Session` automatically returns that type in its
/// completion handler.
public protocol ResponseRepresentable: Decodable {}

/// :nodoc:
extension Array: ResponseRepresentable where Element: ResponseRepresentable {}
