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
///             // The `model` property will be an array of `Statistic` structs.
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
    public typealias ResponseType = [Statistic]
    
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
    /// The `RetrieveStatisticsParameters` class represents the
    struct Parameters: Encodable, Validatable {
        /// Indicates how the statistics should be grouped.
        public let aggregatedBy: Statistic.Aggregation?
        
        /// The starting date of the statistics to retrieve.
        public let startDate: Date
        
        /// The end date of the statistics to retrieve.
        public let endDate: Date?
        
        /// Initializes the request with a start date, as well as an end date and/or
        /// aggregation method.
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
        
        /// Validates that the end date (if present) is not earlier than the start
        /// date, that there are no more than 10 categories specified, and that
        /// there are no more than 10 subusers specified.
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
