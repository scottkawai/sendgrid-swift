import Foundation

public extension Statistic {
    /// Represents the various aggregation methods a stats call can have.
    ///
    /// - day:      Statistic aggregated by day.
    /// - week:     Statistics aggregated by week.
    /// - month:    Statistics aggregated by month.
    enum Aggregation: String, Codable {
        /// Statistics aggregated by day.
        case day

        /// Statistics aggregated by week.
        case week

        /// Statistics aggregated by month.
        case month
    }
}
