import Foundation

/// This struct is used to represent a page via the `limit` and `offset`
/// parameters found in various API calls.
public struct Page {
    // MARK: - Properties
    
    /// The limit value for each page of results.
    public let limit: Int
    
    /// The offset value for the page.
    public let offset: Int
    
    // MARK: - Initialization
    
    /// Initializes the struct with a limit and offset.
    ///
    /// - Parameters:
    ///   - limit:  The number of results per page.
    ///   - offset: The index to start the page on.
    public init(limit: Int, offset: Int) {
        self.limit = limit
        self.offset = offset
    }
}

extension Page: Equatable {
    /// :nodoc:
    /// Equatable conformance.
    public static func ==(lhs: Page, rhs: Page) -> Bool {
        lhs.limit == rhs.limit && lhs.offset == rhs.offset
    }
}
