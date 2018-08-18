
import UIKit
import CircleView
import SimpleButton

public class VoiceInput: UIView {

    var delegate: VoiceInputDelegate?

    //
    // MARK: - 录制界面
    //

    var recordView = UIView()

    var recordButton = CircleView()
    var previewButton = CircleView()
    var deleteButton = CircleView()

    var guideLabel = UILabel()
    var durationLabel = UILabel()

    //
    // MARK: - 预览界面
    //

    var previewView = UIView()

    var progressLabel = UILabel()
    var playButton = CircleView()

    var cancelButton = SimpleButton()
    var sendButton = SimpleButton()

    //
    // MARK: - 录制界面 配置
    //

    var recordButtonRadius = CGFloat(60)
    var recordButtonImage = UIImage(named: "mic")
    var recordButtonBackgroundColorNormal = UIColor(red: 41 / 255, green: 181 / 255, blue: 234 / 255, alpha: 1)
    var recordButtonBackgroundColorPressed = UIColor(red: 14 / 255, green: 164 / 255, blue: 221 / 255, alpha: 1)

    var previewButtonRadius = CGFloat(30)
    var previewButtonImage = UIImage(named: "preview")
    var previewButtonBorderWidth = CGFloat(0.5)
    var previewButtonBorderColor = UIColor(red: 187 / 255, green: 187 / 255, blue: 187 / 255, alpha: 1)
    var previewButtonBackgroundColorNormal = UIColor.white
    var previewButtonBackgroundColorHover = UIColor(red: 243 / 255, green: 243 / 255, blue: 243 / 255, alpha: 1)
    var previewButtonMarginRight = CGFloat(35)

    var deleteButtonRadius = CGFloat(30)
    var deleteButtonImage = UIImage(named: "delete")
    var deleteButtonBorderWidth = CGFloat(0.5)
    var deleteButtonBorderColor = UIColor(red: 187 / 255, green: 187 / 255, blue: 187 / 255, alpha: 1)
    var deleteButtonBackgroundColorNormal = UIColor.white
    var deleteButtonBackgroundColorHover = UIColor(red: 243 / 255, green: 243 / 255, blue: 243 / 255, alpha: 1)
    var deleteButtonMarginLeft = CGFloat(35)

    var guideLabelTextColor = UIColor(red: 160 / 255, green: 160 / 255, blue: 160 / 255, alpha: 1)
    var guideLabelTextFont = UIFont.systemFont(ofSize: 17)
    var guideLabelMarginBottom = CGFloat(30)

    var durationLabelTextColor = UIColor(red: 160 / 255, green: 160 / 255, blue: 160 / 255, alpha: 1)
    var durationLabelTextFont = UIFont.systemFont(ofSize: 17)
    var durationLabelMarginBottom = CGFloat(30)

    var guideTextNormal = "按住说话"
    var guideTextPreview = "松手试听"
    var guideTextDelete = "松手取消发送"

    //
    // MARK: - 预览界面 配置
    //

    var progressLabelTextColor = UIColor(red: 160 / 255, green: 160 / 255, blue: 160 / 255, alpha: 1)
    var progressLabelTextFont = UIFont.systemFont(ofSize: 17)
    var progressLabelMarginBottom = CGFloat(25)

    var playButtonCenterRadius = CGFloat(56)
    var playButtonCenterColor = UIColor.white
    var playButtonCenterColorPressed = UIColor(red: 240 / 255, green: 240 / 255, blue: 240 / 255, alpha: 1)
    var playButtonRingWdith = CGFloat(4)
    var playButtonRingColor = UIColor(red: 230 / 255, green: 230 / 255, blue: 230 / 255, alpha: 1)
    var playButtonTrackColor = UIColor(red: 41 / 255, green: 181 / 255, blue: 234 / 255, alpha: 1)

    var playButtonImage = UIImage(named: "play")
    var stopButtonImage = UIImage(named: "stop")

    var footerButtonTextCancel = "取消"
    var footerButtonTextSend = "发送"

    var fotterButtonPaddingTop = CGFloat(16)
    var fotterButtonPaddingBottom = CGFloat(16)

    var footerButtonTextColor = UIColor(red: 50 / 255, green: 50 / 255, blue: 50 / 255, alpha: 1)
    var footerButtonTextFont = UIFont.systemFont(ofSize: 16)


    var footerButtonBorderColor = UIColor(red: 210 / 255, green: 210 / 255, blue: 210 / 255, alpha: 1)
    var footerButtonBackgroundColorNormal = UIColor.white
    var footerButtonBackgroundColorPressed = UIColor(red: 240 / 255, green: 240 / 255, blue: 240 / 255, alpha: 1)

    //
    // MARK: - 私有属性
    //

    private var isPreviewButtonPressed = false {
        didSet {
            if oldValue == isPreviewButtonPressed {
                return
            }
            if isPreviewButtonPressed {
                previewButton.centerColor = previewButtonBackgroundColorHover
                guideLabel.isHidden = false
                durationLabel.isHidden = true
                guideLabel.text = guideTextPreview
            }
            else {
                previewButton.centerColor = previewButtonBackgroundColorNormal
                guideLabel.isHidden = true
                durationLabel.isHidden = false
                guideLabel.text = guideTextNormal
            }
            previewButton.setNeedsDisplay()
        }
    }

    private var isDeleteButtonPressed = false {
        didSet {
            if oldValue == isDeleteButtonPressed {
                return
            }
            if isDeleteButtonPressed {
                deleteButton.centerColor = deleteButtonBackgroundColorHover
                guideLabel.isHidden = false
                durationLabel.isHidden = true
                guideLabel.text = guideTextDelete
            }
            else {
                deleteButton.centerColor = deleteButtonBackgroundColorNormal
                guideLabel.isHidden = true
                durationLabel.isHidden = false
                guideLabel.text = guideTextNormal
            }
            deleteButton.setNeedsDisplay()
        }
    }

    private var isPreviewing = false {
        didSet {
            if oldValue == isPreviewing {
                return
            }
            if isPreviewing {
                resetPreviewView()
                recordView.isHidden = true
                previewView.isHidden = false
            }
            else {
                recordView.isHidden = false
                previewView.isHidden = true
            }
        }
    }

    private let voiceManager = VoiceManager()

    // 刷新时长的 timer
    var timer: Timer?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        voiceManager.onPermissionsGranted = {
            self.delegate?.voiceInputDidPermissionsGranted(self)
        }
        voiceManager.onPermissionsDenied = {
            self.delegate?.voiceInputDidPermissionsDenied(self)
        }
        voiceManager.onRecordWithoutPermissions = {
            self.delegate?.voiceInputWillRecordWithoutPermissions(self)
        }
        voiceManager.onRecordDurationLessThanMinDuration = {
            self.delegate?.voiceInputDidRecordDurationLessThanMinDuration(self)
        }
        voiceManager.onFinishRecord = { success in
            self.finishRecord()
        }
        voiceManager.onFinishPlay = { success in
            self.finishPlay()
        }
    }
    
    public override func didMoveToSuperview() {
        addRecordView()
        addPreviewView()
    }
    
    /**
     * 请求麦克风权限
     */
    func requestPermissions() {
        voiceManager.requestPermissions()
    }

    private func startTimer(interval: TimeInterval, selector: Selector) {
        print("start timer")
        timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: selector, userInfo: nil, repeats: true)
    }

    private func stopTimer() {
        guard let timer = timer else {
            return
        }
        print("stop timer")
        timer.invalidate()
        self.timer = nil
    }

    @objc private func onDurationUpdate() {
        durationLabel.text = formatDuration(voiceManager.duration)
    }

    @objc private func onProgressUpdate() {
        
        progressLabel.text = formatDuration(voiceManager.progress)
        
        // 接近就直接 1 吧
        // 避免总是不能满圆的情况
        var trackValue = voiceManager.progress / voiceManager.fileDuration
        if (trackValue > 0.995) {
            trackValue = 1
        }
        playButton.trackValue = trackValue
        playButton.setNeedsDisplay()
        
    }

    private func startRecord() {

        do {
            try voiceManager.startRecord()
            
            if voiceManager.isRecording {

                recordButton.centerColor = recordButtonBackgroundColorPressed
                recordButton.setNeedsDisplay()

                previewButton.isHidden = false
                deleteButton.isHidden = false

                guideLabel.isHidden = true
                durationLabel.isHidden = false

                startTimer(interval: 0.1, selector: #selector(VoiceInput.onDurationUpdate))
            }
        }
        catch {
            print(error.localizedDescription)
        }

    }

    private func stopRecord() {

        do {
            try voiceManager.stopRecord()
        }
        catch {
            print(error.localizedDescription)
        }

    }

    private func finishRecord() {
        
        stopTimer()
        
        if voiceManager.filePath != "" {
            if isPreviewButtonPressed {
                isPreviewing = true
            }
            else if isDeleteButtonPressed {
                voiceManager.deleteFile()
            }
            else {
                delegate?.voiceInputDidFinishRecord(self, voiceManager.filePath, voiceManager.fileDuration)
            }
        }

        isPreviewButtonPressed = false
        isDeleteButtonPressed = false

        recordButton.centerColor = recordButtonBackgroundColorNormal
        recordButton.setNeedsDisplay()

        previewButton.isHidden = true
        deleteButton.isHidden = true

        guideLabel.isHidden = false
        durationLabel.isHidden = true

        durationLabel.text = formatDuration(0)

    }

    private func startPlay() {

        do {
            try voiceManager.startPlay()
            if voiceManager.isPlaying {
                playButton.centerImage = stopButtonImage
                playButton.setNeedsDisplay()
                startTimer(interval: 1 / 60, selector: #selector(VoiceInput.onProgressUpdate))
            }
        }
        catch {
            print(error.localizedDescription)
        }

    }

    private func stopPlay() {

        do {
            try voiceManager.stopPlay()
        }
        catch {
            print(error.localizedDescription)
        }

        finishPlay()

    }

    private func finishPlay() {

        stopTimer()

        resetPreviewView()

    }

    private func resetPreviewView() {
        progressLabel.text = formatDuration(voiceManager.fileDuration)
        
        playButton.centerImage = playButtonImage
        playButton.trackValue = 0
        playButton.setNeedsDisplay()
    }

    private func cancel() {
        stopPlay()
        voiceManager.deleteFile()
        isPreviewing = false
    }

    private func send() {
        stopPlay()
        isPreviewing = false
        delegate?.voiceInputDidFinishRecord(self, voiceManager.filePath, voiceManager.fileDuration)
    }

}

//
// MARK: - 界面搭建
//

extension VoiceInput {

    private func addRecordView() {

        recordView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: frame.size)
        addSubview(recordView)

        addRecordButton()
        addPreviewButton()
        addDeleteButton()

        addGuideLabel()
        addDurationLabel()

    }

    private func addRecordButton() {

        recordButton.delegate = self
        recordButton.centerRadius = recordButtonRadius
        recordButton.centerColor = recordButtonBackgroundColorNormal
        recordButton.centerImage = recordButtonImage
        recordButton.ringWidth = 0

        recordButton.sizeToFit()
        recordButton.translatesAutoresizingMaskIntoConstraints = false

        recordView.addSubview(recordButton)

        let centerXConstraint = NSLayoutConstraint(item: recordButton, attribute: .centerX, relatedBy: .equal, toItem: recordView, attribute: .centerX, multiplier: 1.0, constant: 0)

        let centerYConstraint = NSLayoutConstraint(item: recordButton, attribute: .centerY, relatedBy: .equal, toItem: recordView, attribute: .centerY, multiplier: 1.0, constant: 0)

        addConstraints([centerXConstraint, centerYConstraint])

    }

    private func addPreviewButton() {

        previewButton.isHidden = true

        previewButton.centerRadius = previewButtonRadius
        previewButton.centerColor = previewButtonBackgroundColorNormal
        previewButton.centerImage = previewButtonImage
        previewButton.ringWidth = previewButtonBorderWidth
        previewButton.ringColor = previewButtonBorderColor

        previewButton.sizeToFit()
        previewButton.translatesAutoresizingMaskIntoConstraints = false

        recordView.addSubview(previewButton)

        let centerYConstraint = NSLayoutConstraint(item: previewButton, attribute: .centerY, relatedBy: .equal, toItem: recordButton, attribute: .centerY, multiplier: 1.0, constant: 0)

        let trailingConstraint = NSLayoutConstraint(item: previewButton, attribute: .trailing, relatedBy: .equal, toItem: recordButton, attribute: .leading, multiplier: 1.0, constant: -1 * previewButtonMarginRight)

        addConstraints([centerYConstraint, trailingConstraint])

    }

    private func addDeleteButton() {

        deleteButton.isHidden = true

        deleteButton.centerRadius = deleteButtonRadius
        deleteButton.centerColor = deleteButtonBackgroundColorNormal
        deleteButton.centerImage = deleteButtonImage
        deleteButton.ringWidth = deleteButtonBorderWidth
        deleteButton.ringColor = deleteButtonBorderColor

        deleteButton.sizeToFit()
        deleteButton.translatesAutoresizingMaskIntoConstraints = false

        recordView.addSubview(deleteButton)

        let centerYConstraint = NSLayoutConstraint(item: deleteButton, attribute: .centerY, relatedBy: .equal, toItem: recordButton, attribute: .centerY, multiplier: 1.0, constant: 0)

        let leadingConstraint = NSLayoutConstraint(item: deleteButton, attribute: .leading, relatedBy: .equal, toItem: recordButton, attribute: .trailing, multiplier: 1.0, constant: deleteButtonMarginLeft)

        addConstraints([centerYConstraint, leadingConstraint])

    }

    private func addGuideLabel() {

        guideLabel.text = guideTextNormal
        guideLabel.textColor = guideLabelTextColor
        guideLabel.font = guideLabelTextFont

        guideLabel.sizeToFit()
        guideLabel.translatesAutoresizingMaskIntoConstraints = false

        recordView.addSubview(guideLabel)

        let centerXConstraint = NSLayoutConstraint(item: guideLabel, attribute: .centerX, relatedBy: .equal, toItem: recordButton, attribute: .centerX, multiplier: 1.0, constant: 0)

        let bottomConstraint = NSLayoutConstraint(item: guideLabel, attribute: .bottom, relatedBy: .equal, toItem: recordButton, attribute: .top, multiplier: 1.0, constant: -1 * guideLabelMarginBottom)

        addConstraints([centerXConstraint, bottomConstraint])

    }

    private func addDurationLabel() {

        durationLabel.isHidden = true

        durationLabel.text = "00:00"
        durationLabel.textColor = durationLabelTextColor
        durationLabel.font = durationLabelTextFont

        durationLabel.sizeToFit()
        durationLabel.translatesAutoresizingMaskIntoConstraints = false

        recordView.addSubview(durationLabel)

        let centerXConstraint = NSLayoutConstraint(item: durationLabel, attribute: .centerX, relatedBy: .equal, toItem: recordButton, attribute: .centerX, multiplier: 1.0, constant: 0)

        let bottomConstraint = NSLayoutConstraint(item: durationLabel, attribute: .bottom, relatedBy: .equal, toItem: recordButton, attribute: .top, multiplier: 1.0, constant: -1 * durationLabelMarginBottom)

        addConstraints([centerXConstraint, bottomConstraint])

    }

    private func addPreviewView() {

        previewView.isHidden = true
        previewView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: frame.size)
        addSubview(previewView)

        addPlayButton()
        addProgressLabel()
        addCancelButton()
        addSendButton()

    }

    private func addPlayButton() {

        playButton.delegate = self
        playButton.centerRadius = playButtonCenterRadius
        playButton.centerColor = playButtonCenterColor
        playButton.centerImage = playButtonImage
        playButton.ringWidth = playButtonRingWdith
        playButton.ringColor = playButtonRingColor
        playButton.trackWidth = playButtonRingWdith
        playButton.trackColor = playButtonTrackColor

        playButton.sizeToFit()
        playButton.translatesAutoresizingMaskIntoConstraints = false


        previewView.addSubview(playButton)

        let centerXConstraint = NSLayoutConstraint(item: playButton, attribute: .centerX, relatedBy: .equal, toItem: previewView, attribute: .centerX, multiplier: 1.0, constant: 0)

        let centerYConstraint = NSLayoutConstraint(item: playButton, attribute: .centerY, relatedBy: .equal, toItem: previewView, attribute: .centerY, multiplier: 1.0, constant: 0)

        addConstraints([centerXConstraint, centerYConstraint])

    }

    private func addProgressLabel() {

        progressLabel.text = "00:00"
        progressLabel.textColor = progressLabelTextColor
        progressLabel.font = progressLabelTextFont

        progressLabel.sizeToFit()
        progressLabel.translatesAutoresizingMaskIntoConstraints = false

        previewView.addSubview(progressLabel)

        let centerXConstraint = NSLayoutConstraint(item: progressLabel, attribute: .centerX, relatedBy: .equal, toItem: playButton, attribute: .centerX, multiplier: 1.0, constant: 0)

        let bottomConstraint = NSLayoutConstraint(item: progressLabel, attribute: .bottom, relatedBy: .equal, toItem: playButton, attribute: .top, multiplier: 1.0, constant: -1 * progressLabelMarginBottom)

        addConstraints([centerXConstraint, bottomConstraint])


    }

    private func addCancelButton() {

        cancelButton.setTitle(footerButtonTextCancel, for: .normal)
        cancelButton.setTitleColor(footerButtonTextColor, for: .normal)

        cancelButton.titleLabel?.font = footerButtonTextFont

        cancelButton.contentEdgeInsets = UIEdgeInsets(top: fotterButtonPaddingTop, left: 0, bottom: fotterButtonPaddingBottom, right: 0)

        cancelButton.sizeToFit()
        cancelButton.translatesAutoresizingMaskIntoConstraints = false

        previewView.addSubview(cancelButton)

        let bottomConstraint = NSLayoutConstraint(item: cancelButton, attribute: .bottom, relatedBy: .equal, toItem: previewView, attribute: .bottom, multiplier: 1.0, constant: 0)

        let leadingConstraint = NSLayoutConstraint(item: cancelButton, attribute: .leading, relatedBy: .equal, toItem: previewView, attribute: .leading, multiplier: 1.0, constant: 0)

        let trailingConstraint = NSLayoutConstraint(item: cancelButton, attribute: .trailing, relatedBy: .equal, toItem: previewView, attribute: .centerX, multiplier: 1.0, constant: 0)

        addConstraints([bottomConstraint, leadingConstraint, trailingConstraint])

        cancelButton.setBackgroundColor(color: footerButtonBackgroundColorNormal, for: .normal)
        cancelButton.setBackgroundColor(color: footerButtonBackgroundColorPressed, for: .highlighted)

        cancelButton.onPress = {
            self.cancel()
        }

    }

    private func addSendButton() {

        sendButton.setTitle(footerButtonTextSend, for: .normal)
        sendButton.setTitleColor(footerButtonTextColor, for: .normal)

        sendButton.titleLabel?.font = footerButtonTextFont

        sendButton.contentEdgeInsets = UIEdgeInsets(top: fotterButtonPaddingTop, left: 0, bottom: fotterButtonPaddingBottom, right: 0)
        sendButton.sizeToFit()
        sendButton.translatesAutoresizingMaskIntoConstraints = false

        previewView.addSubview(sendButton)

        let bottomConstraint = NSLayoutConstraint(item: sendButton, attribute: .bottom, relatedBy: .equal, toItem: previewView, attribute: .bottom, multiplier: 1.0, constant: 0)

        let leadingConstraint = NSLayoutConstraint(item: sendButton, attribute: .leading, relatedBy: .equal, toItem: previewView, attribute: .centerX, multiplier: 1.0, constant: 0)

        let trailingConstraint = NSLayoutConstraint(item: sendButton, attribute: .trailing, relatedBy: .equal, toItem: previewView, attribute: .trailing, multiplier: 1.0, constant: 0)

        addConstraints([bottomConstraint, leadingConstraint, trailingConstraint])

        sendButton.setBackgroundColor(color: footerButtonBackgroundColorNormal, for: .normal)
        sendButton.setBackgroundColor(color: footerButtonBackgroundColorPressed, for: .highlighted)

        sendButton.onPress = {
            self.send()
        }

    }

    public override func layoutSubviews() {

        cancelButton.setTopBorder(width: 0.5, color: footerButtonBorderColor)

        sendButton.setLeftBorder(width: 0.5, color: footerButtonBorderColor)
        sendButton.setTopBorder(width: 0.5, color: footerButtonBorderColor)

    }

}

//
// MARK: - 圆形按钮的事件响应
//

extension VoiceInput: CircleViewDelegate {

    public func circleViewDidTouchDown(_ circleView: CircleView) {
        if circleView == recordButton {
            if voiceManager.isRecording {
                stopRecord()
            }
            else {
                startRecord()
            }
        }
        else if circleView == playButton {
            playButton.centerColor = playButtonCenterColorPressed
            playButton.setNeedsDisplay()
        }
    }

    public func circleViewDidTouchUp(_ circleView: CircleView, _ inside: Bool) {
        if circleView == recordButton {
            stopRecord()
        }
        else if circleView == playButton {
            playButton.centerColor = playButtonCenterColor
            playButton.setNeedsDisplay()
            if inside {
                if voiceManager.isPlaying {
                    stopPlay()
                }
                else {
                    startPlay()
                }
            }
        }
    }
    
    public func circleViewDidTouchEnter(_ circleView: CircleView) {
        if circleView == playButton {
            playButton.centerColor = playButtonCenterColorPressed
            playButton.setNeedsDisplay()
        }
    }
    
    public func circleViewDidTouchLeave(_ circleView: CircleView) {
        if circleView == playButton {
            playButton.centerColor = playButtonCenterColor
            playButton.setNeedsDisplay()
        }
    }

    public func circleViewDidTouchMove(_ circleView: CircleView, _ x: CGFloat, _ y: CGFloat) {
        if circleView == recordButton {
            
            let offsetY = y - recordButtonRadius
            
            var centerX = -1 * (previewButtonMarginRight + previewButtonRadius + previewButtonBorderWidth)
            var offsetX = x - centerX

            isPreviewButtonPressed = sqrt(offsetX * offsetX + offsetY * offsetY) <= previewButtonRadius
            if isPreviewButtonPressed {
                return
            }

            centerX = 2 * recordButtonRadius + deleteButtonMarginLeft + deleteButtonRadius + deleteButtonBorderWidth
            offsetX = x - centerX

            isDeleteButtonPressed = sqrt(offsetX * offsetX + offsetY * offsetY) <= deleteButtonRadius

        }
    }

}

//
// MARK: - 辅助方法
//

extension VoiceInput {

    private func formatDuration(_ duration: Double) -> String {

        var value = Int(duration)
        if duration < 0 {
            value = 0
        }

        let minutes = value / 60
        let seconds = value - minutes * 60

        var a = String(minutes)
        if minutes < 10 {
            a = "0" + a
        }

        var b = String(seconds)
        if seconds < 10 {
            b = "0" + b
        }

        return "\(a):\(b)"
    }

}
