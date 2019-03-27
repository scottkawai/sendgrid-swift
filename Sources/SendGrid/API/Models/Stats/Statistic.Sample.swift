import Foundation

public extension Statistic {
    /// The `Statistic.Sample` struct represents a single group of statistics,
    /// with the raw stats being made available via the `metrics` property.
    struct Sample: Codable {
        // MARK: - Properties
        
        /// The raw metrics for each email event type.
        public let metrics: Statistic.Metric
        
        /// The name of the sample, if applicable. For instance, if these are
        /// category stats, then this property will have the name of the
        /// category.
        public let name: String?
        
        /// The dimension type these stats have been grouped by.
        public let type: Statistic.Dimension?
        
        // MARK: - Initialization
        
        /// Initializes the struct.
        ///
        /// - Parameters:
        ///   - metrics:    The raw metrics for each email event type.
        ///   - name:       The name of the sample (e.g. the name of the
        ///                 category).
        ///   - type:       The dimension type these stats have been grouped by.
        public init(metrics: Statistic.Metric, name: String? = nil, type: Statistic.Dimension? = nil) {
            self.metrics = metrics
            self.name = name
            self.type = type
        }
    }
}
