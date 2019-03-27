import Foundation

/// The `ContentDisposition` represents the various content-dispositions an
/// attachment can have.
///
/// - inline: Shows the attachment inline with text.
/// - attachment: Shows the attachment below the text.
public enum ContentDisposition: String, Codable {
    // MARK: - Cases
    
    /// The "inline" disposition, which shows the attachment inline with text.
    case inline
    
    /// The "attachment" disposition, which shows the attachment below the text.
    case attachment
}
