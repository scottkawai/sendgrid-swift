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
    class Global {}

    /// :nodoc:
    @available(*, deprecated, renamed: "RetrieveCategoryStatistics")
    class Category {}

    /// :nodoc:
    @available(*, deprecated, renamed: "RetrieveSubuserStatistics")
    class Subuser {}
}
