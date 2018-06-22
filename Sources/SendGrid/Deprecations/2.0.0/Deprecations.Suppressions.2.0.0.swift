//
//  Deprecations.Suppressions.2.0.0.swift
//  SendGrid
//
//  Created by Scott Kawai on 6/22/18.
//

import Foundation

public extension Block {
    /// :nodoc:
    @available(*, deprecated, renamed: "RetrieveBlocks")
    public class Get {}
}

public extension Bounce {
    /// :nodoc:
    @available(*, deprecated, renamed: "RetrieveBounces")
    public class Get {}
}

public extension GlobalUnsubscribe {
    /// :nodoc:
    @available(*, deprecated, renamed: "RetrieveGlobalUnsubscribes")
    public class Get {}
}

public extension InvalidEmail {
    /// :nodoc:
    @available(*, deprecated, renamed: "RetrieveInvalidEmails")
    public class Get {}
}

public extension SpamReport {
    /// :nodoc:
    @available(*, deprecated, renamed: "RetrieveSpamReports")
    public class Get {}
}
