//
//  Statistic.Global.Get.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/20/17.
//

import Foundation

public extension Statistic {
    
    /// The `Statistic.Global` class is used to make the
    /// [Get Global Stats](https://sendgrid.com/docs/API_Reference/Web_API_v3/Stats/global.html)
    /// API call.
    public class Global: StatisticFetcher {
        
        /// The path for the global unsubscribe endpoint.
        override var path: String { return "/v3/stats" }
        
    }
    
}
