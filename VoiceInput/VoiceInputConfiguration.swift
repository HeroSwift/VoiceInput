
import UIKit

// 配置
public class VoiceInputConfiguration {
    
    //
    // MARK: - 录制界面 配置
    //
    
    // 录制按钮半径
    public var recordButtonRadius: CGFloat = 60
    
    // 录制按钮图标
    public var recordButtonImage = UIImage(named: "mic")
    
    // 录制按钮边框大小
    public var recordButtonBorderWidth = 1 / UIScreen.main.scale
    
    // 录制按钮边框颜色
    public var recordButtonBorderColor = UIColor(red: 187 / 255, green: 187 / 255, blue: 187 / 255, alpha: 1)
    
    // 录制按钮默认背景色
    public var recordButtonBackgroundColorNormal = UIColor(red: 41 / 255, green: 181 / 255, blue: 234 / 255, alpha: 1)
    
    // 录制按钮按下时的背景色
    public var recordButtonBackgroundColorPressed = UIColor(red: 14 / 255, green: 164 / 255, blue: 221 / 255, alpha: 1)
    
    // 试听按钮半径
    public var previewButtonRadius: CGFloat = 30
    
    // 试听按钮图标
    public var previewButtonImage = UIImage(named: "preview")
    
    // 试听按钮边框大小
    public var previewButtonBorderWidth = 1 / UIScreen.main.scale
    
    // 试听按钮边框颜色
    public var previewButtonBorderColor = UIColor(red: 187 / 255, green: 187 / 255, blue: 187 / 255, alpha: 1)
    
    // 试听按钮默认背景色
    public var previewButtonBackgroundColorNormal = UIColor.white
    
    // 试听按钮悬浮时的背景色
    public var previewButtonBackgroundColorHover = UIColor(red: 243 / 255, green: 243 / 255, blue: 243 / 255, alpha: 1)
    
    // 试听按钮与录制按钮的距离
    public var previewButtonMarginRight: CGFloat = 35
    
    // 删除按钮半径
    public var deleteButtonRadius: CGFloat = 30
    
    // 删除按钮图标
    public var deleteButtonImage = UIImage(named: "delete")
    
    // 删除按钮边框大小
    public var deleteButtonBorderWidth = 1 / UIScreen.main.scale
    
    // 删除按钮边框颜色
    public var deleteButtonBorderColor = UIColor(red: 187 / 255, green: 187 / 255, blue: 187 / 255, alpha: 1)
    
    // 删除按钮默认背景色
    public var deleteButtonBackgroundColorNormal = UIColor.white
    
    // 删除按钮悬浮时的背景色
    public var deleteButtonBackgroundColorHover = UIColor(red: 243 / 255, green: 243 / 255, blue: 243 / 255, alpha: 1)
    
    // 删除按钮与录制按钮的距离
    public var deleteButtonMarginLeft: CGFloat = 35
    
    // 录音引导文本颜色
    public var guideLabelTextColor = UIColor(red: 160 / 255, green: 160 / 255, blue: 160 / 255, alpha: 1)
    
    // 录音引导文本字体
    public var guideLabelTextFont = UIFont.systemFont(ofSize: 17)
    
    // 录音引导文本与录音按钮的距离
    public var guideLabelMarginBottom: CGFloat = 30
    
    // 录音引导文本 - 未按下
    public var guideTextNormal = "按住说话"
    
    // 录音引导文本 - 按下并移动到试听按钮上方
    public var guideTextPreview = "松手试听"
    
    // 录音引导文本 - 按下并移动到删除按钮上方
    public var guideTextDelete = "松手取消发送"
    
    // 正在录音的时长文本颜色
    public var durationLabelTextColor = UIColor(red: 160 / 255, green: 160 / 255, blue: 160 / 255, alpha: 1)
    
    // 正在录音的时长文本颜色
    public var durationLabelTextFont = UIFont.systemFont(ofSize: 17)
    
    // 正在录音的时长文本与录音按钮的距离
    public var durationLabelMarginBottom: CGFloat = 30
    
    // 试听的进度文本颜色
    public var progressLabelTextColor = UIColor(red: 160 / 255, green: 160 / 255, blue: 160 / 255, alpha: 1)
    
    // 试听的进度文本字体
    public var progressLabelTextFont = UIFont.systemFont(ofSize: 17)
    
    // 试听的进度文本与播放按钮的距离
    public var progressLabelMarginBottom: CGFloat = 25
    
    // 播放按钮半径
    public var playButtonCenterRadius: CGFloat = 56
    
    // 播放按钮中间的默认颜色
    public var playButtonCenterColorNormal = UIColor.white
    
    // 播放按钮中间的按下时的颜色
    public var playButtonCenterColorPressed = UIColor(red: 240 / 255, green: 240 / 255, blue: 240 / 255, alpha: 1)
    
    // 播放按钮圆环的大小
    public var playButtonRingWidth: CGFloat = 4
    
    // 播放按钮圆环的颜色
    public var playButtonRingColor = UIColor(red: 230 / 255, green: 230 / 255, blue: 230 / 255, alpha: 1)
    
    // 播放按钮进度条的颜色
    public var playButtonTrackColor = UIColor(red: 41 / 255, green: 181 / 255, blue: 234 / 255, alpha: 1)
    
    // 播放按钮图标
    public var playButtonImage = UIImage(named: "play")
    
    // 停止按钮图标
    public var stopButtonImage = UIImage(named: "stop")
    
    // 底部的取消按钮文本
    public var footerButtonTextCancel = "取消"
    
    // 底部的发送按钮文本
    public var footerButtonTextSend = "发送"
    
    // 底部按钮的 padding top
    public var footerButtonPaddingTop: CGFloat = 16
    
    // 底部按钮的 padding bottom
    public var footerButtonPaddingBottom: CGFloat = 16

    // 底部按钮的文本颜色
    public var footerButtonTextColor = UIColor(red: 50 / 255, green: 50 / 255, blue: 50 / 255, alpha: 1)
    
    // 底部按钮的文本字体
    public var footerButtonTextFont = UIFont.systemFont(ofSize: 16)
    
    // 底部按钮的边框大小
    public var footerButtonBorderWidth = 1 / UIScreen.main.scale
    
    // 底部按钮的边框颜色
    public var footerButtonBorderColor = UIColor(red: 210 / 255, green: 210 / 255, blue: 210 / 255, alpha: 1)
    
    // 底部按钮的默认背景色
    public var footerButtonBackgroundColorNormal = UIColor.white
    
    // 底部按钮按下时的背景色
    public var footerButtonBackgroundColorPressed = UIColor(red: 240 / 255, green: 240 / 255, blue: 240 / 255, alpha: 1)
    
    
    public init() { }
    
}
