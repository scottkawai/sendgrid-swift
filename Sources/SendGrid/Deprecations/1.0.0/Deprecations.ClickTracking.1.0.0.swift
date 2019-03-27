import Foundation

public extension ClickTracking {
    /// :nodoc:
    @available(*, deprecated, renamed: "init(section:)")
    init(enable: Bool, enablePlainText: Bool? = nil) {
        self.enable = enable
        self.enableText = enablePlainText
    }
}
