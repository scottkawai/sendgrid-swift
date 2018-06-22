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
    
    /// :nodoc:
    @available(*, deprecated, renamed: "DeleteBlocks")
    public class Delete {}
}

public extension Bounce {
    /// :nodoc:
    @available(*, deprecated, renamed: "RetrieveBounces")
    public class Get {}
    
    /// :nodoc:
    @available(*, deprecated, renamed: "DeleteBounces")
    public class Delete {}
}

public extension GlobalUnsubscribe {
    /// :nodoc:
    @available(*, deprecated, renamed: "RetrieveGlobalUnsubscribes")
    public class Get {}
    
    /// :nodoc:
    @available(*, deprecated, renamed: "DeleteGlobalUnsubscribe")
    public class Delete {}
}

public extension InvalidEmail {
    /// :nodoc:
    @available(*, deprecated, renamed: "RetrieveInvalidEmails")
    public class Get {}
    
    /// :nodoc:
    @available(*, deprecated, renamed: "DeleteInvalidEmails")
    public class Delete {}
}

public extension SpamReport {
    /// :nodoc:
    @available(*, deprecated, renamed: "RetrieveSpamReports")
    public class Get {}
    
    /// :nodoc:
    @available(*, deprecated, renamed: "DeleteSpamReports")
    public class Delete {}
}
