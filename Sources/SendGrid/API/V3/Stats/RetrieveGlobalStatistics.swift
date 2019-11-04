import Foundation

/// The `RetrieveGlobalStatistics` class is used to make the
/// [Get Global Stats](https://sendgrid.com/docs/API_Reference/Web_API_v3/Stats/global.html)
/// API call. At minimum you need to specify a start date.
///
/// ```swift
/// do {
///     let now = Date()
///     let lastMonth = now.addingTimeInterval(-2592000) // 30 days
///     let request = RetrieveGlobalStatistics(
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
public class RetrieveGlobalStatistics: StatReader<RetrieveGlobalStatistics.Parameters>, Request {
    /// :nodoc:
    public typealias ResponseType = [Statistic.Set<RetrieveGlobalStatistics.ResponseMetric>]
    
    // MARK: - Initialization
    
    /// Initializes the request with a start date, as well as an end date and/or
    /// aggregation method.
    ///
    /// - Parameters:
    ///   - startDate:      The starting date of the statistics to retrieve.
    ///   - endDate:        The end date of the statistics to retrieve.
    ///   - aggregatedBy:   Indicates how the statistics should be grouped.
    public init(startDate: Date, endDate: Date? = nil, aggregatedBy: Statistic.Aggregation? = nil) {
        let params = RetrieveGlobalStatistics.Parameters(
            startDate: startDate,
            endDate: endDate,
            aggregatedBy: aggregatedBy
        )
        super.init(path: "/v3/stats", parameters: params)
    }
}

public extension RetrieveGlobalStatistics /* Parameters */ {
    /// The `RetrieveGlobalStatistics.Parameters` struct represents the various
    /// parameters that can be specified with the
    /// `RetrieveGlobalStatistics` API request.
    struct Parameters: Encodable, Validatable {
        /// Indicates how the statistics should be grouped.
        public let aggregatedBy: Statistic.Aggregation?
        
        /// The starting date of the statistics to retrieve.
        public let startDate: Date
        
        /// The end date of the statistics to retrieve.
        public let endDate: Date?
        
        /// Initializes the request with a start date, as well as an end date 
        /// and/or aggregation method.
        ///
        /// - Parameters:
        ///   - startDate:      The starting date of the statistics to retrieve.
        ///   - endDate:        The end date of the statistics to retrieve.
        ///   - aggregatedBy:   Indicates how the statistics should be grouped.
        public init(startDate: Date, endDate: Date? = nil, aggregatedBy: Statistic.Aggregation? = nil) {
            self.startDate = startDate
            self.endDate = endDate
            self.aggregatedBy = aggregatedBy
        }
        
        /// Validates that the end date (if present) is not earlier than the 
        /// start date.
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
        }
    }
}

public extension RetrieveGlobalStatistics /* Response Metric */ {
    /// The `RetrieveGlobalStatistics.ResponseMetric` struct represents all the 
    /// raw statistics for a given time period.
    struct ResponseMetric: Decodable {
        // MARK: - Properties
        
        /// The number of block events for the given period.
        public let blocks: Int
        
        /// The number of emails dropped due to the address being on the bounce
        /// list for the given period.
        public let bounceDrops: Int
        
        /// The number of bounce events for the given period.
        public let bounces: Int
        
        /// The number of click events for the given period.
        public let clicks: Int
        
        /// The number of deferred events for the given period.
        public let deferred: Int
        
        /// The number of delivered events for the given period.
        public let delivered: Int
        
        /// The number of invalid email events for the given period.
        public let invalidEmails: Int
        
        /// The number of open events for the given period.
        public let opens: Int
        
        /// The number of processed events for the given period.
        public let processed: Int
        
        /// The number of requests for the given period.
        public let requests: Int
        
        /// The number of emails dropped due to the address being on the spam
        /// report list for the given period.
        public let spamReportDrops: Int
        
        /// The number of spam report events for the given period.
        public let spamReports: Int
        
        /// The number of unique click events for the given period.
        public let uniqueClicks: Int
        
        /// The number of unique open events for the given period.
        public let uniqueOpens: Int
        
        /// The number of emails dropped due to the address being on the
        /// unsubscribe list for the given period.
        public let unsubscribeDrops: Int
        
        /// The number of unsubscribe events for the given period.
        public let unsubscribes: Int
        
        // MARK: - Initialization
        
        /// Initializes the struct.
        ///
        /// - Parameters:
        ///   - blocks:             The number of block events for the given
        ///                         period.
        ///   - bounceDrops:        The number of emails dropped due to the
        ///                         address being on the bounce list for the
        ///                         given period.
        ///   - bounces:            The number of bounce events for the given
        ///                         period.
        ///   - clicks:             The number of click events for the given
        ///                         period.
        ///   - deferred:           The number of deferred events for the given
        ///                         period.
        ///   - delivered:          The number of delivered events for the given
        ///                         period.
        ///   - invalidEmails:      The number of invalid email events for the
        ///                         given period.
        ///   - opens:              The number of open events for the given
        ///                         period.
        ///   - processed:          The number of processed events for the given
        ///                         period.
        ///   - requests:           The number of requests for the given period.
        ///   - spamReportDrops:    The number of emails dropped due to the
        ///                         address being on the spam report list for
        ///                         the given period.
        ///   - spamReports:        The number of spam report events for the
        ///                         given period.
        ///   - uniqueClicks:       The number of unique click events for the
        ///                         given period.
        ///   - uniqueOpens:        The number of unique open events for the
        ///                         given period.
        ///   - unsubscribeDrops:   The number of emails dropped due to the
        ///                         address being on the unsubscribe list for
        ///                         the given period.
        ///   - unsubscribes:       The number of unsubscribe events for the
        ///                         given period.
        public init(blocks: Int,
                    bounceDrops: Int,
                    bounces: Int,
                    clicks: Int,
                    deferred: Int,
                    delivered: Int,
                    invalidEmails: Int,
                    opens: Int,
                    processed: Int,
                    requests: Int,
                    spamReportDrops: Int,
                    spamReports: Int,
                    uniqueClicks: Int,
                    uniqueOpens: Int,
                    unsubscribeDrops: Int,
                    unsubscribes: Int) {
            self.blocks = blocks
            self.bounceDrops = bounceDrops
            self.bounces = bounces
            self.clicks = clicks
            self.deferred = deferred
            self.delivered = delivered
            self.invalidEmails = invalidEmails
            self.opens = opens
            self.processed = processed
            self.requests = requests
            self.spamReportDrops = spamReportDrops
            self.spamReports = spamReports
            self.uniqueClicks = uniqueClicks
            self.uniqueOpens = uniqueOpens
            self.unsubscribeDrops = unsubscribeDrops
            self.unsubscribes = unsubscribes
        }
        
        /// :nodoc:
        enum CodingKeys: String, CodingKey {
            case blocks
            case bounceDrops = "bounce_drops"
            case bounces
            case clicks
            case deferred
            case delivered
            case invalidEmails = "invalid_emails"
            case opens
            case processed
            case requests
            case spamReportDrops = "spam_report_drops"
            case spamReports = "spam_reports"
            case uniqueClicks = "unique_clicks"
            case uniqueOpens = "unique_opens"
            case unsubscribeDrops = "unsubscribe_drops"
            case unsubscribes
        }
    }
}
