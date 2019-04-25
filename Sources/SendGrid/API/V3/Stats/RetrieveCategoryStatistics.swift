import Foundation

/// The `Statistic.Category` class is used to make the
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
///     try Session.shared.send(modeledRequest: request) { result in
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
public class RetrieveCategoryStatistics: RetrieveGlobalStatistics {
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
        let params = RetrieveStatisticsParameters(
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
    
    // MARK: - Methods
    
    /// Validates that there are no more than 10 categories specified.
    public override func validate() throws {
        try super.validate()
        let count = self.parameters?.categories?.count ?? 0
        guard 1...10 ~= count else {
            throw Exception.Statistic.invalidNumberOfCategories
        }
    }
}
