import Foundation

/// The `Statistic` struct represents the enclosing structure of statistics
/// returning from the various stat API calls. It contains the
/// date of the aggregated time period, along with the raw stats.
public struct Statistic: Codable {
    // MARK: - Properties
    
    /// The date for this statistic set.
    public let date: Date
    
    /// The individual stat samples that make up this collection.
    public let stats: [Statistic.Sample]
    
    // MARK: - Initialization
    
    /// Initializes the struct.
    ///
    /// - Parameters:
    ///   - date:   The date for this statistic set.
    ///   - stats:  The individual stat samples that make up this collection.
    public init(date: Date, stats: [Statistic.Sample]) {
        self.date = date
        self.stats = stats
    }
}
