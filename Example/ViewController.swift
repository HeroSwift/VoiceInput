//
//  ViewController.swift
//  Example
//
//  Created by zhujl on 2018/8/15.
//  Copyright © 2018年 finstao. All rights reserved.
//

import UIKit
import VoiceInput

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let input = VoiceInput(configuration: VoiceInputConfiguration())
        
        view.backgroundColor = UIColor(red: 240 / 255, green: 240 / 255, blue: 240 / 255, alpha: 1)
        
        input.translatesAutoresizingMaskIntoConstraints = false
        input.delegate = self
        view.addSubview(input)
        
        view.addConstraints([
            NSLayoutConstraint(item: input, attribute: .top, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -285),
            NSLayoutConstraint(item: input, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: input, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: input, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0),
        ])
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: VoiceInputDelegate {
    
    func voiceInputWillRecordWithoutPermissions(_ voiceInput: VoiceInput) {
        print("no permissions")
    }
    
    func voiceInputDidFinishRecord(_ voiceInput: VoiceInput, audioPath: String, audioDuration: TimeInterval) {
        print("\(audioPath) \(audioDuration)")
    }
    
    func voiceInputDidRecordDurationLessThanMinDuration(_ voiceInput: VoiceInput) {
        print("less than min duration")
    }
    
    func voiceInputDidPermissionsGranted(_ voiceInput: VoiceInput) {
        print("permissions granted")
    }
    
    func voiceInputDidPermissionsDenied(_ voiceInput: VoiceInput) {
        print("permissions denied")
    }
    
}
