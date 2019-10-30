import Foundation

public extension Statistic {
    /// The `Statistic.Dimension` enum represents the different ways the
    /// statistics can be sliced.
    ///
    /// - category: Represents statistics grouped by category.
    /// - subuser:  Represents statistics grouped by subuser.
    enum Dimension: String, Codable {
        /// Represents statistics grouped by category.
        case category

        /// Represents statistics grouped by subuser.
        case subuser
        
        /// Represents statistics grouped by device.
        case device
        
        /// Represents statistics grouped by country.
        case country
    }
}
