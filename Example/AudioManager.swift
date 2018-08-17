
import AVFoundation

// 更多可 https://github.com/genedelisa/AVFoundationRecorder/blob/master/AVFoundation%20Recorder/RecorderViewController.swift

public class AudioManager: NSObject {

    // 录音器
    var recorder: AVAudioRecorder?
    
    // 播放器
    var player: AVAudioPlayer?

    // 是否正在录音
    var isRecording = false
    
    // 是否正在播放
    var isPlaying = false
    
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
    
    // 支持的最长录音时长
    var maxDuration: TimeInterval = 60

    // 录音时长
    var duration: TimeInterval?
    

    
    var onFinishRecord: ((_ success: Bool) -> Void)?
    
    var onFinishPlay: ((_ success: Bool) -> Void)?
    
    func requestPermissions() {
        
        let session = AVAudioSession.sharedInstance()
        
        if session.recordPermission() == .undetermined {
            session.requestRecordPermission { (granted) in
                if granted {
                    DispatchQueue.main.async {
                        print("permission granted")
                        
                        do {
                            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
                        }
                        catch {
                            print("could not set session category")
                            print(error.localizedDescription)
                        }
                        
                        do {
                            try session.setActive(true)
                        }
                        catch {
                            print("could not make session active")
                            print(error.localizedDescription)
                        }
                        
                    }
                }
            }
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
        
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd-HH-mm-ss"
        
        filePath = "\(fileDir)/\(format.string(from: Date()))\(audioExtname)"
        
        guard let filePath = filePath else {
            throw AudioManagerError.savePathIsMissing
        }

        print("file path: \(filePath)")
        
        // 每次录音重置，录完读取真实的时长
        duration = nil
        
        do {
            
            let recordSettings: [String: Any] = [
                AVFormatIDKey: audioFormat,
                AVNumberOfChannelsKey: numberOfChannels,
                AVEncoderAudioQualityKey : audioQuality.rawValue,
                AVEncoderBitRateKey : audioBitRate,
                AVSampleRateKey : audioSampleRate
            ]
            recorder = try AVAudioRecorder(url: URL(fileURLWithPath: filePath), settings: recordSettings)

            if let recorder = recorder {
                recorder.delegate = self
                recorder.isMeteringEnabled = true
                recorder.prepareToRecord()
                recorder.record(forDuration: maxDuration)
                isRecording = true
                
                print("record start")
            }

        }
        catch {
            print("could not init AVAudioRecorder")
            print(error.localizedDescription)
            throw AudioManagerError.recorderIsNotAvailable
        }

    }
    
    func stopRecord() throws {
        
        guard isRecording else {
            throw AudioManagerError.recorderIsNotRunning
        }

        if let recorder = recorder {
            recorder.stop()
        }
        
    }
    
    func startPlay() throws {
        
        guard let filePath = filePath else {
            throw AudioManagerError.audioFileIsNotExisted
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: filePath))
            
            if let player = player {
                player.delegate = self
                player.prepareToPlay()
                player.play()
                isPlaying = true
            }
        }
        catch {
            print(error.localizedDescription)
            throw AudioManagerError.playerIsNotAvailable
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
        
        isPlaying = false
        
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
        
        isRecording = false
        
        if flag {
            // 尝试读时长，读取失败也认为是录制失败
            if let filePath = filePath {
                do {
                    player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: filePath))
                    if let player = player {
                        duration = player.duration
                        onFinishRecord?(true)
                        return
                    }
                }
                catch {
                    print(error.localizedDescription)
                }
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
        isPlaying = false
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
