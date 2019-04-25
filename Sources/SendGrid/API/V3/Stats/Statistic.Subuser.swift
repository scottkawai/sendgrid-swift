import Foundation

/// The `Statistic.Subuser` class is used to make the
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
///     try Session.shared.send(modeledRequest: request) { result in
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
public class RetrieveSubuserStatistics: RetrieveGlobalStatistics {
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
        let params = RetrieveStatisticsParameters(
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
    
    // MARK: - Methods
    
    /// Validates that there are no more than 10 subusers specified.
    public override func validate() throws {
        try super.validate()
        let count = self.parameters?.subusers?.count ?? 0
        guard 1...10 ~= count else {
            throw Exception.Statistic.invalidNumberOfSubusers
        }
    }
}
