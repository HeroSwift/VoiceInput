
import UIKit

public protocol VoiceInputDelegate {
    
    // 点击录音按钮时，发现没权限
    func voiceInputWillRecordWithoutPermissions(_ voiceInput: VoiceInput)
    
    // 录音结束或点击发送时触发
    func voiceInputDidFinishRecord(_ voiceInput: VoiceInput, _ filePath: String, _ duration: TimeInterval)
    
    // 录音时间太短
    func voiceInputDidRecordDurationLessThanMinDuration(_ voiceInput: VoiceInput)
    
    // 用户点击同意授权
    func voiceInputDidPermissionsGranted(_ voiceInput: VoiceInput)
    
    // 用户点击拒绝授权
    func voiceInputDidPermissionsDenied(_ voiceInput: VoiceInput)

}

public extension VoiceInputDelegate {
    
    func voiceInputWillRecordWithoutPermissions(_ voiceInput: VoiceInput) { }
    
    func voiceInputDidFinishRecord(_ voiceInput: VoiceInput, _ filePath: String, _ duration: TimeInterval) { }
    
    func voiceInputDidRecordDurationLessThanMinDuration(_ voiceInput: VoiceInput) { }
    
    func voiceInputDidPermissionsGranted(_ voiceInput: VoiceInput) { }
    
    func voiceInputDidPermissionsDenied(_ voiceInput: VoiceInput) { }
    
}