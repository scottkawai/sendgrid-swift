//
//  StatisticFetcher.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/20/17.
//

import Foundation

public class StatisticFetcher<T : StatisticSampleRepresentable & Codable>: Request<[Statistic.Period<T>]> {
    
    // MARK: - Properties
    //=========================================================================
    
    /// Indicates how the statistics should be grouped.
    public let aggregatedBy: Statistic.Aggregation?
    
    /// The starting date of the statistics to retrieve.
    public let startDate: Date
    
    /// The end date of the statistics to retrieve.
    public let endDate: Date?
    
    /// The format used for dates.
    let dateFormat: String
    
    /// The path for the endpoint.
    var path: String {
        return "/"
    }
    
    /// The query items generated from the various properties.
    var queryItems: [URLQueryItem] {
        let formatter = DateFormatter()
        formatter.dateFormat = self.dateFormat
        var items: [String : String] = [
            "start_date": formatter.string(from: self.startDate)
        ]
        if let e = self.endDate { items["end_date"] = formatter.string(from: e) }
        if let a = self.aggregatedBy { items["aggregated_by"] = a.rawValue }
        return items.map { URLQueryItem(name: $0.key, value: $0.value) }
    }
    
    
    // MARK: - Initialization
    //=========================================================================
    
    /// Initializes the struct with a start date, as well as an end date and/or
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
        let format = "yyyy-MM-dd"
        self.dateFormat = format
        let formatter = DateFormatter()
        formatter.dateFormat = format
        super.init(
            method: .GET,
            contentType: .formUrlEncoded,
            path: self.path,
            encoding: EncodingStrategy(dates: .formatted(formatter), data: .base64),
            decoding: DecodingStrategy(dates: .formatted(formatter), data: .base64)
        )
        self.endpoint?.queryItems = self.queryItems
    }
    
    
    // MARK: - Methods
    //=========================================================================
    
    /// Validates that the end date (if present) is not earlier than the start
    /// date.
    public override func validate() throws {
        try super.validate()
        if let e = self.endDate {
            guard self.startDate.timeIntervalSince(e) < 0 else {
                throw Exception.Statistic.invalidEndDate
            }
        }
    }
    
}
