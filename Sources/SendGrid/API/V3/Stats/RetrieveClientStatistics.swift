import Foundation

/// The `RetrieveClientStatistics` class is used to make the
/// [Get Client Stats](https://sendgrid.api-docs.io/v3.0/stats/retrieve-email-statistics-by-client-type)
/// API call. At minimum you need to specify a start date.
///
/// ```swift
/// do {
///     let now = Date()
///     let lastMonth = now.addingTimeInterval(-2592000) // 30 days
///     let request = RetrieveClientStatistics(
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
public class RetrieveClientStatistics: StatReader<RetrieveGlobalStatistics.Parameters>, Request {
    /// :nodoc:
    public typealias ResponseType = [Statistic.Set<RetrieveClientStatistics.ResponseMetric>]

    // MARK: - Initialization

    /// Initializes the request with a start date, as well as an end date and/or
    /// aggregation method.
    ///
    /// - Parameters:
    ///   - startDate:      The starting date of the statistics to retrieve.
    ///   - endDate:        The end date of the statistics to retrieve.
    ///   - aggregatedBy:   Indicates how the statistics should be grouped.
    public init(startDate: Date, endDate: Date? = nil, aggregatedBy: Statistic.Aggregation? = nil, client: RetrieveClientStatistics.ClientType? = nil) {
        let params = RetrieveGlobalStatistics.Parameters(
            startDate: startDate,
            endDate: endDate,
            aggregatedBy: aggregatedBy
        )
        let path: String
        if let c = client {
            path = "/v3/clients/\(c)/stats"
        } else {
            path = "/v3/clients/stats"
        }
        super.init(path: path, parameters: params)
    }
}

public extension RetrieveClientStatistics /* Client Types */ {
    /// The `RetrieveClientStatistics.ClientType` enum represents the various
    /// segmentations of client stats.
    enum ClientType: String {
        /// Represents an email viewed on a phone.
        case phone

        /// Represents an email viewed on a tablet.
        case tablet

        /// Represents an email viewed in a web client.
        case webmail
        
        /// Represents an email viewed in a desktop client.
        case desktop
    }
}

public extension RetrieveClientStatistics /* Response Type */ {
    /// The `RetrieveClientStatistics.ResponseMetric` struct represents the raw 
    /// open statistics for a given time period.
    struct ResponseMetric: Decodable {
        // MARK: - Properties

        /// The number of open events for the given period.
        public let opens: Int

        /// The number of unique open events for the given period.
        public let uniqueOpens: Int

        // MARK: - Initialization

        /// Initializes the struct.
        ///
        /// - Parameters:
        ///   - opens:              The number of open events for the given
        ///                         period.
        ///   - uniqueOpens:        The number of unique open events for the
        ///                         given period.
        public init(opens: Int, uniqueOpens: Int) {
            self.opens = opens
            self.uniqueOpens = uniqueOpens
        }

        /// :nodoc:
        enum CodingKeys: String, CodingKey {
            case opens
            case uniqueOpens = "unique_opens"
        }
    }
}