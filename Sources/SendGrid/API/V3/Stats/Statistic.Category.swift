//
//  Statistic.Category.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/20/17.
//

import Foundation

public extension Statistic {
    
    /// The `Statistic.Category` class is used to make the
    /// [Get Category Stats](https://sendgrid.com/docs/API_Reference/Web_API_v3/Stats/categories.html)
    /// API call.
    public class Category: Statistic.Global {
        
        // MARK: - Properties
        //======================================================================

        /// The categories to retrieve stats for.
        public let categories: [String]
        
        /// The path for the global unsubscribe endpoint.
        override internal var path: String { return "/v3/categories/stats" }
        
        /// The query parameters used in the request.
        override internal var queryItems: [URLQueryItem] {
            return super.queryItems + self.categories.map { URLQueryItem(name: "categories", value: $0) }
        }
        
        // MARK: - Initialization
        //======================================================================
        
        /// Initializes the request with a start date and categories, as well as
        /// an end date and/or aggregation method.
        ///
        /// - Parameters:
        ///   - startDate:      The starting date of the statistics to retrieve.
        ///   - endDate:        The end date of the statistics to retrieve.
        ///   - aggregatedBy:   Indicates how the statistics should be grouped.
        ///   - categories:     An array of categories to retrieve stats for.
        public init(startDate: Date, endDate: Date? = nil, aggregatedBy: Statistic.Aggregation? = nil, categories: [String]) {
            self.categories = categories
            super.init(startDate: startDate, endDate: endDate, aggregatedBy: aggregatedBy)
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
    
}
