
import UIKit

public protocol VoiceInputDelegate {
    
    func voiceInputDidFinishRecord(_ voiceInput: VoiceInput, _ filePath: String, _ duration: TimeInterval)
    
}

public extension VoiceInputDelegate {
    
    func voiceInputDidFinishRecord(_ voiceInput: VoiceInput, _ filePath: String, _ duration: TimeInterval) { }
    
}
