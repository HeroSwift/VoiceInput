
import AVFoundation

// 更多可 https://github.com/genedelisa/AVFoundationRecorder/blob/master/AVFoundation%20Recorder/RecorderViewController.swift

public class AudioManager: NSObject {

    // 录音器
    var recorder: AVAudioRecorder?
    
    // 播放器
    var player: AVAudioPlayer?

    // 是否正在录音
    var isRecording: Bool {
        get {
            return recorder != nil ? recorder!.isRecording : false
        }
    }
    
    // 是否正在播放
    var isPlaying: Bool {
        get {
            return player != nil ? player!.isPlaying : false
        }
    }
    
    // 文件扩展名
    var audioExtname = ".m4a"
    
    // 音频格式
    var audioFormat = kAudioFormatMPEG4AAC
    
    // 双声道还是单声道
    var numberOfChannels = 2
    
    // 声音质量
    var audioQuality: AVAudioQuality = .high
    
    // 码率
    var audioBitRate = 320000
    
    // 采样率
    var audioSampleRate = 44100.0
    
    // 保存录音文件的目录
    var fileDir = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
    
    // 当前正在录音的文件路径
    var filePath: String?
    
    var fileDuration: TimeInterval = 0
    
    // 支持的最短录音时长
    var minDuration: TimeInterval = 1
    
    // 支持的最长录音时长
    var maxDuration: TimeInterval = 60

    // 录音时长
    var duration: Double {
        get {
            return recorder != nil ? recorder!.currentTime : 0
        }
    }
    
    // 播放进度
    var progress: Double {
        get {
            return player != nil ? player!.currentTime : 0
        }
    }

    var onFinishRecord: ((_ success: Bool) -> Void)?
    
    var onFinishPlay: ((_ success: Bool) -> Void)?
    
    // 读取进入之前的 category
    // 用完音频后再重置回去
    private var defaultCategory = AVAudioSession.sharedInstance().category
    
    func requestPermissions() {
        
        let session = AVAudioSession.sharedInstance()
        
        if session.recordPermission() == .undetermined {
            session.requestRecordPermission { (granted) in
                if granted {
                    print("permission granted")
                }
            }
        }
        
    }
    
    private func setSessionCategory(_ category: String) {
        
        do {
            try AVAudioSession.sharedInstance().setCategory(category)
        }
        catch {
            print("could not set session category: \(category)")
            print(error.localizedDescription)
        }
        
    }
    
    private func setSessionActive(_ active: Bool) {
        
        do {
            try AVAudioSession.sharedInstance().setActive(active)
        }
        catch {
            print("could not set session active: \(active)")
            print(error.localizedDescription)
        }
        
    }
    
    
    func startRecord() throws {
        
        let session = AVAudioSession.sharedInstance()
        
        if session.recordPermission() != .granted {
            throw AudioManagerError.permissionDeny
        }
        
        guard let fileDir = fileDir else {
            throw AudioManagerError.saveDirIsMissing
        }
        
        // 生成录音文件的路径
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd-HH-mm-ss"
        
        filePath = "\(fileDir)/\(format.string(from: Date()))\(audioExtname)"
        
        guard let filePath = filePath else {
            throw AudioManagerError.savePathIsMissing
        }

        print("file path: \(filePath)")
        
        fileDuration = 0

        let recordSettings: [String: Any] = [
            AVFormatIDKey: audioFormat,
            AVNumberOfChannelsKey: numberOfChannels,
            AVEncoderAudioQualityKey : audioQuality.rawValue,
            AVEncoderBitRateKey : audioBitRate,
            AVSampleRateKey : audioSampleRate
        ]
        
        do {
            recorder = try AVAudioRecorder(url: URL(fileURLWithPath: filePath), settings: recordSettings)
        }
        catch {
            print("could not init AVAudioRecorder")
            print(error.localizedDescription)
            throw AudioManagerError.recorderIsNotAvailable
        }
        
        if let recorder = recorder {
            
            // 设置 session
            setSessionCategory(AVAudioSessionCategoryRecord)
            setSessionActive(true)
            
            recorder.delegate = self
            recorder.isMeteringEnabled = true
            recorder.prepareToRecord()
            recorder.record(forDuration: maxDuration)
            
            print("start record")
            
        }

    }
    
    func stopRecord() throws {
        
        guard isRecording else {
            throw AudioManagerError.recorderIsNotRunning
        }

        if let recorder = recorder {
            fileDuration = recorder.currentTime
            recorder.stop()
        }
        
        setSessionCategory(defaultCategory)
        setSessionActive(false)
        
    }
    
    func startPlay() throws {
        
        guard let filePath = filePath else {
            throw AudioManagerError.audioFileIsNotExisted
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: filePath))
        }
        catch {
            print("could not init AVAudioPlayer")
            print(error.localizedDescription)
            throw AudioManagerError.playerIsNotAvailable
        }
        
        if let player = player {
            
            // 独占播放，并且能响应静音键
            // 比如手机在播放音乐，此时开始试听录音，应暂时独占
            setSessionCategory(AVAudioSessionCategorySoloAmbient)
            
            player.delegate = self
            player.prepareToPlay()
            player.play()
            
            print("start play: \(filePath)")
            
        }

    }
    
    func stopPlay() throws {
        
        guard isPlaying else {
            throw AudioManagerError.playerIsNotRunning
        }
        
        if let player = player {
            player.stop()
            self.player = nil
        }
        
        setSessionCategory(defaultCategory)
        
    }
    
    func deleteFile() {
        
        guard let recorder = recorder else {
            return
        }
        
        recorder.deleteRecording()
        
        self.recorder = nil
        self.filePath = nil
        
    }
    
}

extension AudioManager: AVAudioRecorderDelegate {
    
    public func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        if let error = error {
            print("recorder encode error")
            print(error.localizedDescription)
        }
    }
    
    public func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
        print("finish record: \(flag)")
        
        if flag {
            if fileDuration >= minDuration {
                onFinishRecord?(true)
                return
            }
        }
        
        deleteFile()
        onFinishRecord?(false)
        
    }
    
}

extension AudioManager: AVAudioPlayerDelegate {
    
    public func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let error = error {
            print("player encode error")
            print(error.localizedDescription)
        }
    }
    
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("finish play: \(flag)")
        onFinishPlay?(flag)
    }
    
}

extension AudioManager {
    
    enum AudioManagerError: Swift.Error {
        
        // 没有指定录音目录
        case saveDirIsMissing
        
        // 没有指定录音文件的路径
        case savePathIsMissing
        
        // 没有录音权限
        case permissionDeny
        
        // 录音器不可用
        case recorderIsNotAvailable
        
        // 录音器没在运行中
        case recorderIsNotRunning
        
        // 没有录音文件
        case audioFileIsNotExisted
        
        // 播放器没在运行中
        case playerIsNotRunning
        
        // 播放器不可用
        case playerIsNotAvailable
        
    }
}
