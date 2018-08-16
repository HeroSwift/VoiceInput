
import UIKit
import CircleView

public class VoiceInput: UIView {
    
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
    
    var cancelButton = UIButton()
    var sendButton = UIButton()
    
    //
    // MARK: - 录制界面 配置
    //
    
    var recordButtonRadius = CGFloat(50)
    var recordButtonImage = UIImage(named: "mic")
    var recordButtonBackgroundColorNormal = UIColor(red: 41 / 255, green: 181 / 255, blue: 234 / 255, alpha: 1)
    var recordButtonBackgroundColorPressed = UIColor(red: 14 / 255, green: 164 / 255, blue: 221 / 255, alpha: 1)
    
    var previewButtonRadius = CGFloat(25)
    var previewButtonImage = UIImage(named: "preview")
    var previewButtonBorderWidth = CGFloat(0.5)
    var previewButtonBorderColor = UIColor(red: 187 / 255, green: 187 / 255, blue: 187 / 255, alpha: 1)
    var previewButtonBackgroundColorNormal = UIColor.white
    var previewButtonBackgroundColorHover = UIColor(red: 243 / 255, green: 243 / 255, blue: 243 / 255, alpha: 1)
    var previewButtonMarginRight = CGFloat(30)
    
    var deleteButtonRadius = CGFloat(25)
    var deleteButtonImage = UIImage(named: "delete")
    var deleteButtonBorderWidth = CGFloat(0.5)
    var deleteButtonBorderColor = UIColor(red: 187 / 255, green: 187 / 255, blue: 187 / 255, alpha: 1)
    var deleteButtonBackgroundColorNormal = UIColor.white
    var deleteButtonBackgroundColorHover = UIColor(red: 243 / 255, green: 243 / 255, blue: 243 / 255, alpha: 1)
    var deleteButtonMarginLeft = CGFloat(30)
    
    var guideLabelTextColor = UIColor(red: 187 / 255, green: 187 / 255, blue: 187 / 255, alpha: 1)
    var guideLabelTextFont = UIFont.systemFont(ofSize: 15)
    var guideLabelMarginBottom = CGFloat(25)
    
    var durationLabelTextColor = UIColor(red: 187 / 255, green: 187 / 255, blue: 187 / 255, alpha: 1)
    var durationLabelTextFont = UIFont.systemFont(ofSize: 15)
    var durationLabelMarginBottom = CGFloat(25)
    
    var guideTextNormal = "按住说话"
    var guideTextPreview = "松手试听"
    var guideTextDelete = "松手取消发送"
    
    //
    // MARK: - 预览界面 配置
    //
    
    var progressLabelTextColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
    var progressLabelTextFont = UIFont.systemFont(ofSize: 15)
    var progressLabelMarginBottom = CGFloat(25)
    
    var footerButtonCancelText = "取消"
    var footerButtonSendText = "发送"
    
    var footerButtonTextColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
    var footerButtonTextFont = UIFont.systemFont(ofSize: 15)
    
    
    var footerButtonBorderColor = UIColor(red: 210 / 255, green: 210 / 255, blue: 210 / 255, alpha: 1)
    var footerButtonBackgroundColorNormal = UIColor.white
    var footerButtonBackgroundColorPressed = UIColor(red: 250 / 255, green: 250 / 255, blue: 250 / 255, alpha: 1)
    
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
                recordView.isHidden = true
                previewView.isHidden = false
            }
            else {
                recordView.isHidden = false
                previewView.isHidden = true
            }
        }
    }
    
    private let audioManager = AudioManager()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        backgroundColor = UIColor(red: 245 / 255, green: 245 / 255, blue: 245 / 255, alpha: 1)
    }
    
    public func addLayout() {
        

        addRecordView()
        
        addPreviewView()
        

    }
    
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
        recordButton.ringWidth = 0
        recordButton.setImage(recordButtonImage!)
        
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
        previewButton.ringWidth = previewButtonBorderWidth
        previewButton.ringColor = previewButtonBorderColor
        previewButton.setImage(previewButtonImage!)
        
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
        deleteButton.ringWidth = deleteButtonBorderWidth
        deleteButton.ringColor = deleteButtonBorderColor
        deleteButton.setImage(deleteButtonImage!)
        
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
        
        cancelButton.setTitle(footerButtonCancelText, for: .normal)
        cancelButton.setTitleColor(footerButtonTextColor, for: .normal)
        cancelButton.titleLabel?.font = footerButtonTextFont
        
        cancelButton.contentEdgeInsets = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
        
        cancelButton.sizeToFit()
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        previewView.addSubview(cancelButton)

        let bottomConstraint = NSLayoutConstraint(item: cancelButton, attribute: .bottom, relatedBy: .equal, toItem: previewView, attribute: .bottom, multiplier: 1.0, constant: 0)
        
        let leadingConstraint = NSLayoutConstraint(item: cancelButton, attribute: .leading, relatedBy: .equal, toItem: previewView, attribute: .leading, multiplier: 1.0, constant: 0)
        
        let trailingConstraint = NSLayoutConstraint(item: cancelButton, attribute: .trailing, relatedBy: .equal, toItem: previewView, attribute: .centerX, multiplier: 1.0, constant: 0)
        
        addConstraints([bottomConstraint, leadingConstraint, trailingConstraint])
        
        cancelButton.addTarget(self, action: #selector(self.cancel), for: .touchUpInside)
        
    }
    
    private func addSendButton() {
        
        sendButton.setTitle(footerButtonSendText, for: .normal)
        sendButton.setTitleColor(footerButtonTextColor, for: .normal)
        sendButton.titleLabel?.font = footerButtonTextFont
        
        sendButton.contentEdgeInsets = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
        sendButton.sizeToFit()
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        
        previewView.addSubview(sendButton)
        
        let bottomConstraint = NSLayoutConstraint(item: sendButton, attribute: .bottom, relatedBy: .equal, toItem: previewView, attribute: .bottom, multiplier: 1.0, constant: 0)
        
        let leadingConstraint = NSLayoutConstraint(item: sendButton, attribute: .leading, relatedBy: .equal, toItem: previewView, attribute: .centerX, multiplier: 1.0, constant: 0)
        
        let trailingConstraint = NSLayoutConstraint(item: sendButton, attribute: .trailing, relatedBy: .equal, toItem: previewView, attribute: .trailing, multiplier: 1.0, constant: 0)

        addConstraints([bottomConstraint, leadingConstraint, trailingConstraint])
        
        sendButton.addTarget(self, action: #selector(self.send), for: .touchUpInside)
        
    }
    
    private func startRecord() {
        recordButton.centerColor = recordButtonBackgroundColorPressed
        recordButton.setNeedsDisplay()
        
        previewButton.isHidden = false
        deleteButton.isHidden = false
        
        guideLabel.isHidden = true
        durationLabel.isHidden = false
        
    }
    
    private func stopRecord() {
        
        if isPreviewButtonPressed {
            isPreviewing = true
        }
        else if isDeleteButtonPressed {
            
        }
        
        isPreviewButtonPressed = false
        isDeleteButtonPressed = false
        
        recordButton.centerColor = recordButtonBackgroundColorNormal
        recordButton.setNeedsDisplay()
        
        previewButton.isHidden = true
        deleteButton.isHidden = true
        
        guideLabel.isHidden = false
        durationLabel.isHidden = true
        
    }
    
    @objc private func cancel() {
        isPreviewing = false
    }
    
    @objc private func send() {
        isPreviewing = false
    }
    
    private func startPlay() {
        
    }
    
    private func stopPlay() {
        
    }
    
    public override func layoutSubviews() {
        
        addTopBorder(view: cancelButton, color: footerButtonBorderColor)
        
        addLeftBorder(view: sendButton, color: footerButtonBorderColor)
        addTopBorder(view: sendButton, color: footerButtonBorderColor)
        
    }
    
}

extension VoiceInput: CircleViewDelegate {
    
    public func circleViewDidTouchDown(_ circleView: CircleView) {
        if circleView == recordButton {
            if audioManager.isRecording {
                stopRecord()
            }
            else {
                startRecord()
            }
        }
        else if circleView == playButton {
            if audioManager.isPlaying {
                stopPlay()
            }
            else {
                startPlay()
            }
        }
    }
    
    public func circleViewDidTouchUp(_ circleView: CircleView, _ inside: Bool) {
        if circleView == recordButton {
            stopRecord()
        }
    }
    
    public func circleViewDidTouchMove(_ circleView: CircleView, _ x: CGFloat, _ y: CGFloat) {
        if circleView == recordButton {
            
            let previewButtonCenterX = -1 * (previewButtonMarginRight + previewButtonRadius + previewButtonBorderWidth)
            let previewButtonCenterY = recordButtonRadius
            
            var offsetX = x - previewButtonCenterX
            var offsetY = y - previewButtonCenterY
            
            isPreviewButtonPressed = sqrt(offsetX * offsetX + offsetY * offsetY) <= previewButtonRadius
            if isPreviewButtonPressed {
                return
            }
            
            let deleteButtonCenterX = 2 * recordButtonRadius + deleteButtonMarginLeft + deleteButtonRadius + deleteButtonBorderWidth
            let deleteButtonCenterY = recordButtonRadius
            
            offsetX = x - deleteButtonCenterX
            offsetY = y - deleteButtonCenterY
            
            isDeleteButtonPressed = sqrt(offsetX * offsetX + offsetY * offsetY) <= deleteButtonRadius
            
        }
    }
    
}

extension VoiceInput {
    
    private func addLeftBorder(view: UIView, color: UIColor) {
        let leftBorder = CALayer()
        leftBorder.frame = CGRect(x: 0, y: 0, width: 0.5, height: view.frame.size.height)
        leftBorder.backgroundColor = color.cgColor
        view.layer.addSublayer(leftBorder)
    }
    
    private func addTopBorder(view: UIView, color: UIColor) {
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 0.5)
        topBorder.backgroundColor = color.cgColor
        view.layer.addSublayer(topBorder)
    }
    
}
