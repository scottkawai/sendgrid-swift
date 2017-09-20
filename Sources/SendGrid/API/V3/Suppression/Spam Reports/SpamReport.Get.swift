//
//  SpamReport.Get.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/19/17.
//

import Foundation

public extension SpamReport {
    
    /// The `SpamReport.Get` class represents the API call to [retrieve the
    /// spam reports list](https://sendgrid.com/docs/API_Reference/Web_API_v3/spam_reports.html#List-all-spam-reports-GET).
    public class Get: SuppressionListReader<SpamReport> {
        
        /// The path to the spam reports API.
        override var path: String { return "/v3/suppression/spam_reports" }
        
    }
    
}
