import Foundation

public extension Metric {
    /// The `Metric.Open` struct represents the raw open statistics for a given
    /// time period.
    struct Open: Decodable {
        // MARK: - Properties
        
        /// The number of open events for the given period.
        public let opens: Int
        
        /// The number of unique open events for the given period.
        public let uniqueOpens: Int
        
        // MARK: - Initialization
        
        /// Initializes the struct.
        ///
        /// - Parameters:
        ///   - opens:              The number of open events for the given
        ///                         period.
        ///   - uniqueOpens:        The number of unique open events for the
        ///                         given period.
        public init(opens: Int, uniqueOpens: Int) {
            self.opens = opens
            self.uniqueOpens = uniqueOpens
        }
    }
}

public extension Metric.Open /* Decodable Conformance */ {
    /// :nodoc:
    enum CodingKeys: String, CodingKey {
        case opens
        case uniqueOpens = "unique_opens"
    }
}
