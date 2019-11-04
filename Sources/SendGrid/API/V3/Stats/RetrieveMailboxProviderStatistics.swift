import Foundation

/// The `RetrieveMailboxProviderStatistics` class is used to make the
/// [Get Mailbox Provider Stats](https://sendgrid.api-docs.io/v3.0/stats/retrieve-email-statistics-by-mailbox-provider)
/// API call. At minimum you need to specify a start date.
///
/// ```swift
/// do {
///     let now = Date()
///     let lastMonth = now.addingTimeInterval(-2592000) // 30 days
///     let request = RetrieveMailboxProviderStatistics(
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
public class RetrieveMailboxProviderStatistics: StatReader<RetrieveMailboxProviderStatistics.Parameters>, Request {
    /// :nodoc:
    public typealias ResponseType = [Statistic.Set<RetrieveMailboxProviderStatistics.ResponseMetric>]
    
    // MARK: - Initialization
    
    /// Initializes the request with a start date, as well as an end date and/or
    /// aggregation method.
    ///
    /// - Parameters:
    ///   - startDate:          The starting date of the statistics to retrieve.
    ///   - endDate:            The end date of the statistics to retrieve.
    ///   - aggregatedBy:       Indicates how the statistics should be grouped.
    ///   - mailboxProviders:   The mail box providers to get statistics for.
    ///                         You can include up to 10.
    public init(startDate: Date, endDate: Date? = nil, aggregatedBy: Statistic.Aggregation? = nil, mailboxProviders: [String]? = nil) {
        let params = RetrieveMailboxProviderStatistics.Parameters(
            startDate: startDate,
            endDate: endDate,
            aggregatedBy: aggregatedBy,
            mailboxProviders: mailboxProviders
        )
        super.init(path: "/v3/mailbox_providers/stats", parameters: params)
    }
    
    /// Initializes the request with a start date, as well as an end date and/or
    /// aggregation method.
    ///
    /// - Parameters:
    ///   - startDate:          The starting date of the statistics to retrieve.
    ///   - endDate:            The end date of the statistics to retrieve.
    ///   - aggregatedBy:       Indicates how the statistics should be grouped.
    ///   - mailboxProviders:   The mail box providers to get statistics for.
    ///                         You can include up to 10.
    public convenience init(startDate: Date, endDate: Date? = nil, aggregatedBy: Statistic.Aggregation? = nil, mailboxProviders: String...) {
        self.init(startDate: startDate, endDate: endDate, aggregatedBy: aggregatedBy, mailboxProviders: mailboxProviders)
    }
}

public extension RetrieveMailboxProviderStatistics /* Parameters */ {
    /// The `RetrieveMailboxProviderStatistics.Parameters` struct represents the
    /// various parameters that can be specified with the
    /// `RetrieveMailboxProviderStatistics` API request.
    struct Parameters: Encodable, Validatable {
        /// Indicates how the statistics should be grouped.
        public let aggregatedBy: Statistic.Aggregation?
        
        /// The starting date of the statistics to retrieve.
        public let startDate: Date
        
        /// The end date of the statistics to retrieve.
        public let endDate: Date?
        
        /// The mailbox providers to retrieve stats for.
        public let mailboxProviders: [String]?
        
        /// Initializes the request with a start date, as well as an end date
        /// and/or aggregation method.
        ///
        /// - Parameters:
        ///   - startDate:          The starting date of the statistics to
        ///                         retrieve.
        ///   - endDate:            The end date of the statistics to retrieve.
        ///   - aggregatedBy:       Indicates how the statistics should be
        ///                         grouped.
        ///   - mailboxProviders:   The mail box providers to get statistics
        ///                         for. You can include up to 10.
        public init(startDate: Date, endDate: Date? = nil, aggregatedBy: Statistic.Aggregation? = nil, mailboxProviders: [String]? = nil) {
            self.startDate = startDate
            self.endDate = endDate
            self.aggregatedBy = aggregatedBy
            self.mailboxProviders = mailboxProviders
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
            
            if let mp = self.mailboxProviders {
                guard 1...10 ~= mp.count else {
                    throw Exception.Statistic.invalidNumberOfMailboxProviders
                }
            }
        }
        
        /// :nodoc:
        public enum CodingKeys: String, CodingKey {
            case startDate = "start_date"
            case endDate = "end_date"
            case aggregatedBy = "aggregated_by"
            case mailboxProviders = "mailbox_providers"
        }
    }
}

public extension RetrieveMailboxProviderStatistics /* Response Type */ {
    struct ResponseMetric: Decodable {
        // MARK: - Properties
        
        /// The number of block events for the given period.
        public let blocks: Int
        
        /// The number of bounce events for the given period.
        public let bounces: Int
        
        /// The number of click events for the given period.
        public let clicks: Int
        
        /// The number of deferred events for the given period.
        public let deferred: Int
        
        /// The number of delivered events for the given period.
        public let delivered: Int
        
        /// The number of drop events for the given period.
        public let drops: Int
        
        /// The number of open events for the given period.
        public let opens: Int
        
        /// The number of spam report events for the given period.
        public let spamReports: Int
        
        /// The number of unique click events for the given period.
        public let uniqueClicks: Int
        
        /// The number of unique open events for the given period.
        public let uniqueOpens: Int
        
        // MARK: - Initialization
        
        /// Initializes the struct.
        ///
        /// - Parameters:
        ///   - blocks:             The number of block events for the given
        ///                         period.
        ///   - bounces:            The number of bounce events for the given
        ///                         period.
        ///   - clicks:             The number of click events for the given
        ///                         period.
        ///   - deferred:           The number of deferred events for the given
        ///                         period.
        ///   - delivered:          The number of delivered events for the given
        ///                         period.
        ///   - drops:              The number of drop events for the given
        ///                         period.
        ///   - opens:              The number of open events for the given
        ///                         period.
        ///   - spamReports:        The number of spam report events for the
        ///                         given period.
        ///   - uniqueClicks:       The number of unique click events for the
        ///                         given period.
        ///   - uniqueOpens:        The number of unique open events for the
        ///                         given period.
        public init(blocks: Int,
                    bounceDrops: Int,
                    bounces: Int,
                    clicks: Int,
                    deferred: Int,
                    delivered: Int,
                    drops: Int,
                    opens: Int,
                    spamReports: Int,
                    uniqueClicks: Int,
                    uniqueOpens: Int) {
            self.blocks = blocks
            self.bounces = bounces
            self.clicks = clicks
            self.deferred = deferred
            self.delivered = delivered
            self.drops = drops
            self.opens = opens
            self.spamReports = spamReports
            self.uniqueClicks = uniqueClicks
            self.uniqueOpens = uniqueOpens
        }
        
        /// :nodoc:
        enum CodingKeys: String, CodingKey {
            case blocks
            case bounces
            case clicks
            case deferred
            case delivered
            case drops
            case opens
            case spamReports = "spam_reports"
            case uniqueClicks = "unique_clicks"
            case uniqueOpens = "unique_opens"
        }
    }
}
