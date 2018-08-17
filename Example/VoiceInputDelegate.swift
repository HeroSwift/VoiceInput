
import UIKit

public protocol VoiceInputDelegate {
    
    // 点击录音按钮时，发现没权限
    func voiceInputWillRecordWithoutPermission(_ voiceInput: VoiceInput)
    
    // 录音完成
    func voiceInputDidFinishRecord(_ voiceInput: VoiceInput, _ filePath: String, _ duration: TimeInterval)
    
    // 用户点击同意授权
    func voiceInputDidPermissionGranted(_ voiceInput: VoiceInput)
    
    // 用户点击拒绝授权
    func voiceInputDidPermissionDenied(_ voiceInput: VoiceInput)

}

public extension VoiceInputDelegate {
    
    func voiceInputWillRecordWithoutPermission(_ voiceInput: VoiceInput) { }
    
    func voiceInputDidFinishRecord(_ voiceInput: VoiceInput, _ filePath: String, _ duration: TimeInterval) { }
    
    func voiceInputDidPermissionGranted(_ voiceInput: VoiceInput) { }
    
    func voiceInputDidPermissionDenied(_ voiceInput: VoiceInput) { }
    
}
