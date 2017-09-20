//
//  Bounce.Get.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/19/17.
//

import Foundation

public extension Bounce {
    
    /// The `Bounce.Get` class represents the API call to [retrieve the bounce
    /// list](https://sendgrid.com/docs/API_Reference/Web_API_v3/bounces.html#List-all-bounces-GET).
    public class Get: SuppressionListReader<Bounce> {
        
        /// The path for the bounces API endpoint.
        override var path: String { return "/v3/suppression/bounces" }
        
    }
    
}
