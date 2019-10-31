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
    public typealias ResponseType = [Statistic.Set<Metric.Open>]

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
    enum ClientType: String {
        case phone
        case tablet
        case webmail
        case desktop
    }
}
