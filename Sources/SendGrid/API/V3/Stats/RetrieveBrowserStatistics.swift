import Foundation

/// The `RetrieveBrowserStatistics` class is used to make the
/// [Get Browser Stats](https://sendgrid.api-docs.io/v3.0/stats/retrieve-email-statistics-by-browser)
/// API call. At minimum you need to specify a start date.
///
/// ```swift
/// do {
///     let now = Date()
///     let lastMonth = now.addingTimeInterval(-2592000) // 30 days
///     let request = RetrieveBrowserStatistics(
///         startDate: lastMonth,
///         endDate: now,
///         aggregatedBy: .week
///     )
///     try Session.shared.send(request: request) { result in
///         switch result {
///         case .success(_, let model):
///             // The `model` property will be an array of `Statistic.Set` structs.
///             model.forEach { _ in
///                 // Do something with the stats here...
///             }
///         case .failure(let err):
///             print(err)
///         }
///     }
/// } catch {
///     print(error)
/// }
/// ```
public class RetrieveBrowserStatistics: StatReader<RetrieveBrowserStatistics.Parameters>, Request {
    /// :nodoc:
    public typealias ResponseType = [Statistic.Set<RetrieveBrowserStatistics.ResponseMetric>]
    
    // MARK: - Initialization
    
    /// Initializes the request with a start date, as well as an end date and/or
    /// aggregation method.
    ///
    /// - Parameters:
    ///   - startDate:      The starting date of the statistics to retrieve.
    ///   - endDate:        The end date of the statistics to retrieve.
    ///   - aggregatedBy:   Indicates how the statistics should be grouped.
    ///   - browsers:       The mail box providers to get statistics for. You
    ///                     can include up to 10.
    public init(startDate: Date, endDate: Date? = nil, aggregatedBy: Statistic.Aggregation? = nil, browsers: [String]? = nil) {
        let params = RetrieveBrowserStatistics.Parameters(
            startDate: startDate,
            endDate: endDate,
            aggregatedBy: aggregatedBy,
            browsers: browsers
        )
        super.init(path: "/v3/browsers/stats", parameters: params)
    }
    
    /// Initializes the request with a start date, as well as an end date and/or
    /// aggregation method.
    ///
    /// - Parameters:
    ///   - startDate:      The starting date of the statistics to retrieve.
    ///   - endDate:        The end date of the statistics to retrieve.
    ///   - aggregatedBy:   Indicates how the statistics should be grouped.
    ///   - browsers:       The mail box providers to get statistics for. You
    ///                     can include up to 10.
    public convenience init(startDate: Date, endDate: Date? = nil, aggregatedBy: Statistic.Aggregation? = nil, browsers: String...) {
        self.init(startDate: startDate, endDate: endDate, aggregatedBy: aggregatedBy, browsers: browsers)
    }
}

public extension RetrieveBrowserStatistics /* Parameters */ {
    /// The `RetrieveBrowserStatistics.Parameters` struct represents the
    /// various parameters that can be specified with the
    /// `RetrieveBrowserStatistics` API request.
    struct Parameters: Encodable, Validatable {
        /// Indicates how the statistics should be grouped.
        public let aggregatedBy: Statistic.Aggregation?
        
        /// The starting date of the statistics to retrieve.
        public let startDate: Date
        
        /// The end date of the statistics to retrieve.
        public let endDate: Date?
        
        /// The browsers to retrieve stats for.
        public let browsers: [String]?
        
        /// Initializes the request with a start date, as well as an end date
        /// and/or aggregation method.
        ///
        /// - Parameters:
        ///   - startDate:      The starting date of the statistics to retrieve.
        ///   - endDate:        The end date of the statistics to retrieve.
        ///   - aggregatedBy:   Indicates how the statistics should be grouped.
        ///   - browsers:       The mail box providers to get statistics for.
        ///                     You can include up to 10.
        public init(startDate: Date, endDate: Date? = nil, aggregatedBy: Statistic.Aggregation? = nil, browsers: [String]? = nil) {
            self.startDate = startDate
            self.endDate = endDate
            self.aggregatedBy = aggregatedBy
            self.browsers = browsers
        }
        
        /// Validates that the end date (if present) is not earlier than the
        /// start date and that there are no more than 10 mailbox providers
        /// specified.
        public func validate() throws {
            if let e = self.endDate {
                guard self.startDate < e else {
                    throw Exception.Statistic.invalidEndDate
                }
            }
            
            if let b = self.browsers {
                guard 1...10 ~= b.count else {
                    throw Exception.Statistic.invalidNumberOfBrowsers
                }
            }
        }
        
        /// :nodoc:
        public enum CodingKeys: String, CodingKey {
            case startDate = "start_date"
            case endDate = "end_date"
            case aggregatedBy = "aggregated_by"
            case browsers
        }
    }
}

public extension RetrieveBrowserStatistics /* Response Type */ {
    struct ResponseMetric: Decodable {
        // MARK: - Properties
        
        /// The number of click events for the given period.
        public let clicks: Int
        
        /// The number of unique click events for the given period.
        public let uniqueClicks: Int
        
        // MARK: - Initialization
        
        /// Initializes the struct.
        ///
        /// - Parameters:
        ///   - clicks:             The number of click events for the given
        ///                         period.
        ///   - uniqueClicks:       The number of unique click events for the
        ///                         given period.
        public init(clicks: Int, uniqueClicks: Int) {
            self.clicks = clicks
            self.uniqueClicks = uniqueClicks
        }
        
        /// :nodoc:
        enum CodingKeys: String, CodingKey {
            case clicks
            case uniqueClicks = "unique_clicks"
        }
    }
}
