import Foundation

public extension Metric {
    /// The `Metric.Engagement` struct represents all the engagement statistics
    /// for a given time period.
    struct Engagement: Decodable {
        // MARK: - Properties
        
        /// The number of click events for the given period.
        public let clicks: Int
        
        /// The number of open events for the given period.
        public let opens: Int
        
        /// The number of unique click events for the given period.
        public let uniqueClicks: Int
        
        /// The number of unique open events for the given period.
        public let uniqueOpens: Int
        
        // MARK: - Initialization
        
        /// Initializes the struct.
        ///
        /// - Parameters:
        ///   - clicks:             The number of click events for the given
        ///                         period.
        ///   - opens:              The number of open events for the given
        ///                         period.
        ///   - uniqueClicks:       The number of unique click events for the
        ///                         given period.
        ///   - uniqueOpens:        The number of unique open events for the
        ///                         given period.
        public init(clicks: Int, opens: Int, uniqueClicks: Int, uniqueOpens: Int) {
            self.clicks = clicks
            self.opens = opens
            self.uniqueClicks = uniqueClicks
            self.uniqueOpens = uniqueOpens
        }
    }
}

public extension Metric.Engagement /* Decodable Conformance */ {
    /// :nodoc:
    enum CodingKeys: String, CodingKey {
        case clicks
        case opens
        case uniqueClicks = "unique_clicks"
        case uniqueOpens = "unique_opens"
    }
}
