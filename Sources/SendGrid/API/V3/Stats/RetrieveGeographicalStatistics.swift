import Foundation

/// The `RetrieveGeographicalStatistics` class is used to make the
/// [Get Geo Stats](https://sendgrid.api-docs.io/v3.0/stats/retrieve-email-statistics-by-country-and-state-province)
/// API call. At minimum you need to specify a start date.
///
/// ```swift
/// do {
///     let now = Date()
///     let lastMonth = now.addingTimeInterval(-2592000) // 30 days
///     let request = RetrieveGeographicalStatistics(
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
public class RetrieveGeographicalStatistics: StatReader<RetrieveGeographicalStatistics.Parameters>, Request {
    /// :nodoc:
    public typealias ResponseType = [Statistic.Set<RetrieveGeographicalStatistics.ResponseMetric>]
    
    // MARK: - Initialization
    
    /// Initializes the request with a start date, as well as an end date and/or
    /// aggregation method.
    ///
    /// - Parameters:
    ///   - startDate:      The starting date of the statistics to retrieve.
    ///   - endDate:        The end date of the statistics to retrieve.
    ///   - aggregatedBy:   Indicates how the statistics should be grouped.
    ///   - country:        The country to retrieve stats for.
    public init(startDate: Date, endDate: Date? = nil, aggregatedBy: Statistic.Aggregation? = nil, country: RetrieveGeographicalStatistics.Country? = nil) {
        let params = RetrieveGeographicalStatistics.Parameters(
            startDate: startDate,
            endDate: endDate,
            aggregatedBy: aggregatedBy,
            country: country
        )
        super.init(path: "/v3/geo/stats", parameters: params)
    }
}

public extension RetrieveGeographicalStatistics /* Parameters */ {
    /// `RetrieveGeographicalStatistics.Country` represents the various
    /// countries that statistics can be retrieved for.
    enum Country: String, Encodable {
        case UnitedStates = "US"
        case Canada = "CA"
    }
    
    /// The `RetrieveGeographicalStatistics.Parameters` struct represents the
    /// various parameters that can be specified with the
    /// `RetrieveGeographicalStatistics` API request.
    struct Parameters: Encodable, Validatable {
        /// Indicates how the statistics should be grouped.
        public let aggregatedBy: Statistic.Aggregation?
        
        /// The starting date of the statistics to retrieve.
        public let startDate: Date
        
        /// The end date of the statistics to retrieve.
        public let endDate: Date?
        
        /// The country to retrieve stats for.
        public let country: RetrieveGeographicalStatistics.Country?
        
        /// Initializes the request with a start date, as well as an end date and/or
        /// aggregation method.
        ///
        /// - Parameters:
        ///   - startDate:      The starting date of the statistics to retrieve.
        ///   - endDate:        The end date of the statistics to retrieve.
        ///   - aggregatedBy:   Indicates how the statistics should be grouped.
        ///   - country:        The country to retrieve stats for.
        public init(startDate: Date, endDate: Date? = nil, aggregatedBy: Statistic.Aggregation? = nil, country: RetrieveGeographicalStatistics.Country? = nil) {
            self.startDate = startDate
            self.endDate = endDate
            self.aggregatedBy = aggregatedBy
            self.country = country
        }
        
        /// Validates that the end date (if present) is not earlier than the start
        /// date.
        public func validate() throws {
            if let e = self.endDate {
                guard self.startDate < e else {
                    throw Exception.Statistic.invalidEndDate
                }
            }
        }
        
        /// :nodoc:
        public enum CodingKeys: String, CodingKey {
            case startDate = "start_date"
            case endDate = "end_date"
            case aggregatedBy = "aggregated_by"
            case country
        }
    }
}

public extension RetrieveGeographicalStatistics /* Response Metric */ {
    /// The `RetrieveGeographicalStatistics.ResponseMetric` struct represents
    /// all the engagement statistics for a given time period.
    struct ResponseMetric: Decodable {
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
        
        /// :nodoc:
        enum CodingKeys: String, CodingKey {
            case clicks
            case opens
            case uniqueClicks = "unique_clicks"
            case uniqueOpens = "unique_opens"
        }
    }
}
