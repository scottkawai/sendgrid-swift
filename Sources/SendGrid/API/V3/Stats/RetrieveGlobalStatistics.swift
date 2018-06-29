//
//  RetrieveGlobalStatistics.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/20/17.
//

import Foundation

/// The `Statistic.Global` class is used to make the
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
///     try Session.shared.send(request: request) { (response) in
///         // The `model` property will be an array of `Statistic` structs.
///         response?.model?.forEach{ (stat) in
///             // Do something with the stats here...
///         }
///     }
/// } catch {
///     print(error)
/// }
/// ```
public class RetrieveGlobalStatistics: Request<[Statistic], RetrieveStatisticsParameters> {
    
    // MARK: - Initialization
    //=========================================================================
    
    /// Initializes the request with a path and set of parameters.
    ///
    /// - Parameters:
    ///   - path:       The path of the endpoint.
    ///   - parameters: The parameters used in the API call.
    internal init(path: String, parameters: RetrieveStatisticsParameters) {
        let format = "yyyy-MM-dd"
        let formatter = DateFormatter()
        formatter.dateFormat = format
        
        super.init(
            method: .GET,
            path: path,
            parameters: parameters,
            encodingStrategy: EncodingStrategy(dates: .formatted(formatter), data: .base64),
            decodingStrategy: DecodingStrategy(dates: .formatted(formatter), data: .base64)
        )
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
    
    
    // MARK: - Methods
    //=========================================================================
    
    /// Validates that the end date (if present) is not earlier than the start
    /// date.
    public override func validate() throws {
        try super.validate()
        if let e = self.parameters?.endDate, let s = self.parameters?.startDate {
            guard s.timeIntervalSince(e) < 0 else {
                throw Exception.Statistic.invalidEndDate
            }
        }
    }
}

/// The `RetrieveStatisticsParameters` class represents the
public class RetrieveStatisticsParameters: Codable {
    
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
    
    /// :nodoc:
    public enum CodingKeys: String, CodingKey {
        
        case startDate = "start_date"
        case endDate = "end_date"
        case aggregatedBy = "aggregated_by"
        case categories
        case subusers
        
    }
    
}
