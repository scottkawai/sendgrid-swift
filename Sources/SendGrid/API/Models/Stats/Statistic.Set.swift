import Foundation

public extension Statistic {
    /// The `Statistic` struct represents the enclosing structure of statistics
    /// returning from the various stat API calls. It contains the
    /// date of the aggregated time period, along with the raw stats.
    struct Set<MetricType: Decodable>: ResponseRepresentable {
        // MARK: - Properties
        
        /// The date for this statistic set.
        public let date: Date
        
        /// The individual stat samples that make up this collection.
        public let stats: [Statistic.Sample<MetricType>]
        
        // MARK: - Initialization
        
        /// Initializes the struct.
        ///
        /// - Parameters:
        ///   - date:   The date for this statistic set.
        ///   - stats:  The individual stat samples that make up this collection.
        public init(date: Date, stats: [Statistic.Sample<MetricType>]) {
            self.date = date
            self.stats = stats
        }
    }
}
