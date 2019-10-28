import Foundation

/// The `RetrieveSubuserStatistics` class is used to make the
/// [Get Subuser Stats](https://sendgrid.com/docs/API_Reference/Web_API_v3/Stats/subusers.html)
/// API call. At minimum you need to specify a start date.
///
/// ```swift
/// do {
///     let now = Date()
///     let lastMonth = now.addingTimeInterval(-2592000) // 30 days
///     let request = RetrieveSubuserStatistics(
///         startDate: lastMonth,
///         endDate: now,
///         aggregatedBy: .week,
///         subusers: "Foo", "Bar"
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
public class RetrieveSubuserStatistics: StatReader<RetrieveSubuserStatistics.Parameters>, Request {
    /// :nodoc:
    public typealias ResponseType = [Statistic]
    
    // MARK: - Initialization
    
    /// Initializes the request with a start date and subusers, as well as
    /// an end date and/or aggregation method.
    ///
    /// - Parameters:
    ///   - startDate:      The starting date of the statistics to retrieve.
    ///   - endDate:        The end date of the statistics to retrieve.
    ///   - aggregatedBy:   Indicates how the statistics should be grouped.
    ///   - subusers:       An array of subuser usernames to retrieve stats
    ///                     for (max 10).
    public init(startDate: Date, endDate: Date? = nil, aggregatedBy: Statistic.Aggregation? = nil, subusers: [String]) {
        let params = RetrieveSubuserStatistics.Parameters(
            startDate: startDate,
            endDate: endDate,
            aggregatedBy: aggregatedBy,
            subusers: subusers
        )
        super.init(path: "/v3/subusers/stats", parameters: params)
    }
    
    /// Initializes the request with a start date and subusers, as well as
    /// an end date and/or aggregation method.
    ///
    /// - Parameters:
    ///   - startDate:      The starting date of the statistics to retrieve.
    ///   - endDate:        The end date of the statistics to retrieve.
    ///   - aggregatedBy:   Indicates how the statistics should be grouped.
    ///   - subusers:       An array of subuser usernames to retrieve stats
    ///                     for (max 10).
    public convenience init(startDate: Date, endDate: Date? = nil, aggregatedBy: Statistic.Aggregation? = nil, subusers: String...) {
        self.init(startDate: startDate, endDate: endDate, aggregatedBy: aggregatedBy, subusers: subusers)
    }
    
    /// Initializes the request with a start date and subusers, as well as
    /// an end date and/or aggregation method.
    ///
    /// - Parameters:
    ///   - startDate:      The starting date of the statistics to retrieve.
    ///   - endDate:        The end date of the statistics to retrieve.
    ///   - aggregatedBy:   Indicates how the statistics should be grouped.
    ///   - subusers:       An array of `Subuser` instances to retrieve
    ///                     stats for (max 10).
    public convenience init(startDate: Date, endDate: Date? = nil, aggregatedBy: Statistic.Aggregation? = nil, subusers: [SendGrid.Subuser]) {
        let names = subusers.map { $0.username }
        self.init(startDate: startDate, endDate: endDate, aggregatedBy: aggregatedBy, subusers: names)
    }
    
    /// Initializes the request with a start date and subusers, as well as
    /// an end date and/or aggregation method.
    ///
    /// - Parameters:
    ///   - startDate:      The starting date of the statistics to retrieve.
    ///   - endDate:        The end date of the statistics to retrieve.
    ///   - aggregatedBy:   Indicates how the statistics should be grouped.
    ///   - subusers:       An array of `Subuser` instances to retrieve
    ///                     stats for (max 10).
    public convenience init(startDate: Date, endDate: Date? = nil, aggregatedBy: Statistic.Aggregation? = nil, subusers: SendGrid.Subuser...) {
        self.init(startDate: startDate, endDate: endDate, aggregatedBy: aggregatedBy, subusers: subusers)
    }
}

public extension RetrieveSubuserStatistics /* Parameters */ {
    /// The `RetrieveStatisticsParameters` class represents the
    struct Parameters: Encodable, Validatable {
        /// Indicates how the statistics should be grouped.
        public let aggregatedBy: Statistic.Aggregation?
        
        /// The starting date of the statistics to retrieve.
        public let startDate: Date
        
        /// The end date of the statistics to retrieve.
        public let endDate: Date?
        
        /// The subusers to retrieve stats for.
        public let subusers: [String]
        
        /// Initializes the request with a start date, as well as an end date and/or
        /// aggregation method.
        ///
        /// - Parameters:
        ///   - startDate:      The starting date of the statistics to retrieve.
        ///   - endDate:        The end date of the statistics to retrieve.
        ///   - aggregatedBy:   Indicates how the statistics should be grouped.
        public init(startDate: Date, endDate: Date? = nil, aggregatedBy: Statistic.Aggregation? = nil, subusers: [String]) {
            self.startDate = startDate
            self.endDate = endDate
            self.aggregatedBy = aggregatedBy
            self.subusers = subusers
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
            
            guard 1...10 ~= self.subusers.count else {
                throw Exception.Statistic.invalidNumberOfSubusers
            }
        }
        
        /// :nodoc:
        public enum CodingKeys: String, CodingKey {
            case startDate = "start_date"
            case endDate = "end_date"
            case aggregatedBy = "aggregated_by"
            case subusers
        }
    }
}
