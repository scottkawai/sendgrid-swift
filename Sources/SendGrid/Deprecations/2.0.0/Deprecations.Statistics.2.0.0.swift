//
//  Deprecations.Statistics.2.0.0.swift
//  SendGrid
//
//  Created by Scott Kawai on 6/22/18.
//

import Foundation

public extension Statistic {
    
    /// :nodoc:
    @available(*, deprecated, renamed: "RetrieveGlobalStatistics")
    public class Global {}
    
    /// :nodoc:
    @available(*, deprecated, renamed: "RetrieveCategoryStatistics")
    public class Category {}
    
    /// :nodoc:
    @available(*, deprecated, renamed: "RetrieveSubuserStatistics")
    public class Subuser {}
    
}
