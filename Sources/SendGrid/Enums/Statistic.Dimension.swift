import Foundation

public extension Statistic {
    /// The `Statistic.Dimension` enum represents the different ways the
    /// statistics can be sliced.
    enum Dimension: String, Codable {
        /// Represents statistics grouped by category.
        case category
        
        /// Represents statistics grouped by subuser.
        case subuser
        
        /// Represents statistics grouped by device.
        case device
        
        /// Represents statistics grouped by country.
        case country
        
        /// Represents statistics grouped by client.
        case client
        
        /// Represents statistics grouped by mailbox provider.
        case mailboxProvider = "mailbox_provider"
        
        /// Represents statistics grouped by browser.
        case browser
    }
}
