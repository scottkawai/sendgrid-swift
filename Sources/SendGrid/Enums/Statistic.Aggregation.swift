//
//  Statistic.Aggregation.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/20/17.
//

import Foundation

public extension Statistic {
    
    /// Represents the various aggregation methods a stats call can have.
    ///
    /// - day:      Statistic aggregated by day.
    /// - week:     Statistics aggregated by week.
    /// - month:    Statistics aggregated by month.
    public enum Aggregation: String, Decodable {
        case day, week, month
    }
    
}
