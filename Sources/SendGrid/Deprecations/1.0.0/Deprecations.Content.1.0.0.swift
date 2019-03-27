import Foundation

public extension Content {
    /// :nodoc:
    @available(*, deprecated, renamed: "plainText(body:)")
    static func plainTextContent(_ value: String) -> Content { return .plainText(body: value) }

    /// :nodoc:
    @available(*, deprecated, renamed: "html(body:)")
    static func htmlContent(_ value: String) -> Content { return .html(body: value) }

    /// :nodoc:
    @available(*, deprecated, renamed: "emailBody(plain:html:)")
    static func emailContent(plain: String, html: String) -> [Content] { return Content.emailBody(plain: plain, html: html) }
}
