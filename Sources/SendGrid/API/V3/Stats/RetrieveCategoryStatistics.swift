import Foundation

/// The `RetrieveCategoryStatistics` class is used to make the
/// [Get Category Stats](https://sendgrid.com/docs/API_Reference/Web_API_v3/Stats/categories.html)
/// API call. At minimum you need to specify a start date.
///
/// ```swift
/// do {
///     let now = Date()
///     let lastMonth = now.addingTimeInterval(-2592000) // 30 days
///     let request = RetrieveCategoryStatistics(
///         startDate: lastMonth,
///         endDate: now,
///         aggregatedBy: .week,
///         categories: "Foo", "Bar"
///     )
///     try Session.shared.send(request: request) { result in
///         switch result {
///         case .success(_, let model):
///             // The `model` variable will be an array of `Statistic` structs.
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
public class RetrieveCategoryStatistics: StatReader<RetrieveCategoryStatistics.Parameters>, Request {
    /// :nodoc:
    public typealias ResponseType = [Statistic]
    
    // MARK: - Initialization
    
    /// Initializes the request with a start date and categories, as well as
    /// an end date and/or aggregation method.
    ///
    /// - Parameters:
    ///   - startDate:      The starting date of the statistics to retrieve.
    ///   - endDate:        The end date of the statistics to retrieve.
    ///   - aggregatedBy:   Indicates how the statistics should be grouped.
    ///   - categories:     An array of categories to retrieve stats for.
    public init(startDate: Date, endDate: Date? = nil, aggregatedBy: Statistic.Aggregation? = nil, categories: [String]) {
        let params = RetrieveCategoryStatistics.Parameters(
            startDate: startDate,
            endDate: endDate,
            aggregatedBy: aggregatedBy,
            categories: categories
        )
        super.init(path: "/v3/categories/stats", parameters: params)
    }
    
    /// Initializes the request with a start date and categories, as well as
    /// an end date and/or aggregation method.
    ///
    /// - Parameters:
    ///   - startDate:      The starting date of the statistics to retrieve.
    ///   - endDate:        The end date of the statistics to retrieve.
    ///   - aggregatedBy:   Indicates how the statistics should be grouped.
    ///   - categories:     An array of categories to retrieve stats for.
    public convenience init(startDate: Date, endDate: Date? = nil, aggregatedBy: Statistic.Aggregation? = nil, categories: String...) {
        self.init(startDate: startDate, endDate: endDate, aggregatedBy: aggregatedBy, categories: categories)
    }
}

public extension RetrieveCategoryStatistics /* Parameters */ {
    /// The `RetrieveStatisticsParameters` class represents the
    struct Parameters: Encodable, Validatable {
        /// Indicates how the statistics should be grouped.
        public let aggregatedBy: Statistic.Aggregation?
        
        /// The starting date of the statistics to retrieve.
        public let startDate: Date
        
        /// The end date of the statistics to retrieve.
        public let endDate: Date?
        
        /// The categories to retrieve stats for.
        public let categories: [String]
        
        /// Initializes the request with a start date, as well as an end date and/or
        /// aggregation method.
        ///
        /// - Parameters:
        ///   - startDate:      The starting date of the statistics to retrieve.
        ///   - endDate:        The end date of the statistics to retrieve.
        ///   - aggregatedBy:   Indicates how the statistics should be grouped.
        public init(startDate: Date, endDate: Date? = nil, aggregatedBy: Statistic.Aggregation? = nil, categories: [String]) {
            self.startDate = startDate
            self.endDate = endDate
            self.aggregatedBy = aggregatedBy
            self.categories = categories
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
            
            guard 1...10 ~= self.categories.count else {
                throw Exception.Statistic.invalidNumberOfCategories
            }
        }
        
        /// :nodoc:
        public enum CodingKeys: String, CodingKey {
            case startDate = "start_date"
            case endDate = "end_date"
            case aggregatedBy = "aggregated_by"
            case categories
        }
    }
}
