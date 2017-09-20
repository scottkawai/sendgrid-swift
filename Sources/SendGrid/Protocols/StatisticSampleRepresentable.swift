//
//  StatisticSampleRepresentable.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/20/17.
//

import Foundation

public protocol StatisticSampleRepresentable {
    
    // MARK: - Properties
    //=========================================================================
    
    /// The raw metrics for each email event type.
    var metrics: Statistic.Metric { get }
    
}
