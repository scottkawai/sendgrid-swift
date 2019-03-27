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
    class Get {}

    /// :nodoc:
    @available(*, deprecated, renamed: "DeleteBlocks")
    class Delete {}
}

public extension Bounce {
    /// :nodoc:
    @available(*, deprecated, renamed: "RetrieveBounces")
    class Get {}

    /// :nodoc:
    @available(*, deprecated, renamed: "DeleteBounces")
    class Delete {}
}

public extension GlobalUnsubscribe {
    /// :nodoc:
    @available(*, deprecated, renamed: "RetrieveGlobalUnsubscribes")
    class Get {}

    /// :nodoc:
    @available(*, deprecated, renamed: "DeleteGlobalUnsubscribe")
    class Delete {}
}

public extension InvalidEmail {
    /// :nodoc:
    @available(*, deprecated, renamed: "RetrieveInvalidEmails")
    class Get {}

    /// :nodoc:
    @available(*, deprecated, renamed: "DeleteInvalidEmails")
    class Delete {}
}

public extension SpamReport {
    /// :nodoc:
    @available(*, deprecated, renamed: "RetrieveSpamReports")
    class Get {}

    /// :nodoc:
    @available(*, deprecated, renamed: "DeleteSpamReports")
    class Delete {}
}
