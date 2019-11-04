import Foundation

public extension Exception {
    /// The `Exception.Statistic` enum represents all the errors that can be thrown
    /// on the statistics calls.
    enum Statistic: Error, CustomStringConvertible {
        /// Thrown if the end date is before the start date.
        case invalidEndDate
        
        /// Thrown if more than 10 categories are specified in the category
        /// stats call.
        case invalidNumberOfCategories
        
        /// Thrown if more than 10 subusers are specified in the subuser stats
        /// call.
        case invalidNumberOfSubusers
        
        /// Thrown if more than 10 mailbox providers are specified.
        case invalidNumberOfMailboxProviders
        
        /// Thrown if more than 10 browsers providers are specified.
        case invalidNumberOfBrowsers
        
        /// A description of the error.
        public var description: String {
            switch self {
            case .invalidEndDate:
                return "The end date cannot be any earlier in time than the start date."
            case .invalidNumberOfCategories:
                return "Invalid number of categories specified. You must specify at least 1, and no more than 10."
            case .invalidNumberOfSubusers:
                return "Invalid number of subusers specified. You must specify at least 1, and no more than 10."
            case .invalidNumberOfMailboxProviders:
                return "Invalid number of mailbox providers specified. You must specify at least 1, and no more than 10."
            case .invalidNumberOfBrowsers:
                return "Invalid number of browsers specified. You must specify at least 1, and no more than 10."
            }
        }
    }
}
