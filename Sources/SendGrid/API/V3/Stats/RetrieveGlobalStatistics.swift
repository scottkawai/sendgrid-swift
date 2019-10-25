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
public class RetrieveGlobalStatistics: Request {
    /// :nodoc:
    public typealias ResponseType = [Statistic]
    
    /// :nodoc:
    public let path: String
    
    /// :nodoc:
    public let method: HTTPMethod = .GET
    
    /// :nodoc:
    public var parameters: RetrieveStatisticsParameters?
    
    /// :nodoc:
    public let encodingStrategy: EncodingStrategy
    
    /// :nodoc:
    public let decodingStrategy: DecodingStrategy
    
    // MARK: - Initialization
    
    /// Initializes the request with a path and set of parameters.
    ///
    /// - Parameters:
    ///   - path:       The path of the endpoint.
    ///   - parameters: The parameters used in the API call.
    internal init(path: String, parameters: RetrieveStatisticsParameters) {
        let format = "yyyy-MM-dd"
        let formatter = DateFormatter()
        formatter.dateFormat = format
        
        self.path = path
        self.parameters = parameters
        self.encodingStrategy = EncodingStrategy(dates: .formatted(formatter), data: .base64)
        self.decodingStrategy = DecodingStrategy(dates: .formatted(formatter), data: .base64)
    }
    
    /// Initializes the request with a start date, as well as an end date and/or
    /// aggregation method.
    ///
    /// - Parameters:
    ///   - startDate:      The starting date of the statistics to retrieve.
    ///   - endDate:        The end date of the statistics to retrieve.
    ///   - aggregatedBy:   Indicates how the statistics should be grouped.
    public convenience init(startDate: Date, endDate: Date? = nil, aggregatedBy: Statistic.Aggregation? = nil) {
        let params = RetrieveStatisticsParameters(
            startDate: startDate,
            endDate: endDate,
            aggregatedBy: aggregatedBy
        )
        self.init(path: "/v3/stats", parameters: params)
    }
}

/// The `RetrieveStatisticsParameters` class represents the
public class RetrieveStatisticsParameters: Codable, Validatable {
    /// Indicates how the statistics should be grouped.
    public let aggregatedBy: Statistic.Aggregation?
    
    /// The starting date of the statistics to retrieve.
    public let startDate: Date
    
    /// The end date of the statistics to retrieve.
    public let endDate: Date?
    
    /// The categories to retrieve stats for.
    public let categories: [String]?
    
    /// The subusers to retrieve stats for.
    public let subusers: [String]?
    
    /// Initializes the request with a start date, as well as an end date and/or
    /// aggregation method.
    ///
    /// - Parameters:
    ///   - startDate:      The starting date of the statistics to retrieve.
    ///   - endDate:        The end date of the statistics to retrieve.
    ///   - aggregatedBy:   Indicates how the statistics should be grouped.
    public init(startDate: Date, endDate: Date? = nil, aggregatedBy: Statistic.Aggregation? = nil, categories: [String]? = nil, subusers: [String]? = nil) {
        self.startDate = startDate
        self.endDate = endDate
        self.aggregatedBy = aggregatedBy
        self.categories = categories
        self.subusers = subusers
    }
    
    /// Validates that the end date (if present) is not earlier than the start
    /// date, that there are no more than 10 categories specified, and that 
    /// there are no more than 10 subusers specified.
    public func validate() throws {
        if let e = self.endDate {
            guard self.startDate.timeIntervalSince(e) < 0 else {
                throw Exception.Statistic.invalidEndDate
            }
        }
        
        if let categoryCount = self.categories?.count {
            guard 1...10 ~= categoryCount else {
                throw Exception.Statistic.invalidNumberOfCategories
            }
        }
        
        if let subuserCount = self.subusers?.count {
            guard 1...10 ~= subuserCount else {
                throw Exception.Statistic.invalidNumberOfSubusers
            }
        }
    }
    
    /// :nodoc:
    public enum CodingKeys: String, CodingKey {
        case startDate = "start_date"
        case endDate = "end_date"
        case aggregatedBy = "aggregated_by"
        case categories
        case subusers
    }
}
