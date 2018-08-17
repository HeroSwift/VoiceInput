//
//  ViewController.swift
//  Example
//
//  Created by zhujl on 2018/8/15.
//  Copyright © 2018年 finstao. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let input = VoiceInput()
        input.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        input.backgroundColor = UIColor(red: 240 / 255, green: 240 / 255, blue: 240 / 255, alpha: 1)
        view.addSubview(input)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

