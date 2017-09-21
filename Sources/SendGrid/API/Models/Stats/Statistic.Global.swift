//
//  Global.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/20/17.
//

import Foundation

public extension Statistic {
    
    /// The `Statistic.Global` struct represents the stats returned from the "Global
    /// Stats" endpoint.
    public struct Global: StatisticSampleRepresentable, Decodable {
        
        /// The raw metrics for each email event type.
        public let metrics: Metric
        
    }
    
}
