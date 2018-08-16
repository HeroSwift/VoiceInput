
import AVFoundation

public class AudioManager {

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
    var audioBitRate = 32000
    
    // 采样率
    var audioSampleRate = 44100.0
    
    // 保存录音文件的目录
    var saveDir = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
    
    // 当前正在录音的文件路径
    var savePath: String?
    
    // 刷新时长的 timer
    var timer: Timer?
    
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1000 / 60, target: self, selector: #selector(AudioManager.onTimeUpdate), userInfo: nil, repeats: false)
    }
    
    private func stopTimer() {
        guard let timer = timer else {
            return
        }
        timer.invalidate()
        self.timer = nil
    }
    
    @objc private func onTimeUpdate() {
        
    }
    
    func requestPermissions() -> Bool {
        
        let session = AVAudioSession.sharedInstance()
        
        switch (session.recordPermission()) {
            
        case AVAudioSessionRecordPermission.granted:
            // 已获取权限
            return true
            
        case AVAudioSessionRecordPermission.denied:
            break
            
        case AVAudioSessionRecordPermission.undetermined:
            session.requestRecordPermission { (granted) in
                
            }
        }
        
        return false
        
    }
    
    
    func startRecoring() throws {
        
        if !requestPermissions() {
            throw AudioManagerError.permissionDeny
        }
        
        guard let saveDir = saveDir else {
            throw AudioManagerError.saveDirIsMissing
        }
        
        savePath = "\(saveDir)/\(NSDate().timeIntervalSince1970)\(audioExtname)"
        
        guard let savePath = savePath else {
            throw AudioManagerError.savePathIsMissing
        }
        
        
        let session = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(AVAudioSessionCategoryRecord)
            try session.setActive(true)
            
            let recordSettings: [String: Any] = [
                AVFormatIDKey: Int(audioFormat),
                AVNumberOfChannelsKey: numberOfChannels,
                AVEncoderAudioQualityKey : audioQuality.rawValue,
                AVEncoderBitRateKey : audioBitRate,
                AVSampleRateKey : audioSampleRate
            ]
            recorder = try AVAudioRecorder(url: URL(fileURLWithPath: savePath), settings: recordSettings)

            if let recorder = recorder {
                recorder.isMeteringEnabled = true
                recorder.prepareToRecord()
                recorder.record()
                isRecording = true
            }

        }
        catch {
            print(error.localizedDescription)
            throw AudioManagerError.recorderIsNotAvailable
        }

    }
    
    func stopRecording() throws {
        
        guard isRecording else {
            throw AudioManagerError.recorderIsNotRunning
        }
        
        if let recorder = recorder {
            recorder.stop()
            self.recorder = nil
        }
        
        isRecording = false
        
    }
    
    func startPlaying() throws {
        
        guard let savePath = savePath else {
            throw AudioManagerError.audioFileIsNotExisted
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: savePath))
            
            if let player = player {
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
    
    func stopPlaying() throws {
        
        guard isPlaying else {
            throw AudioManagerError.playerIsNotRunning
        }
        
        if let player = player {
            player.stop()
            self.player = nil
        }
        
        isPlaying = false
        
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
