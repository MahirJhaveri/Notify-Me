//
//  AlertViewController.swift
//  Alarm
//
//  Created by Mahir Jhaveri  on 1/14/19.
//  Copyright © 2019 Mahir Jhaveri . All rights reserved.
//

import UIKit
import AVFoundation

class AlertViewController: UIViewController {
    
    private var musicEffect: AVAudioPlayer = AVAudioPlayer()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Returns exact path of audio file
        let musicFile = Bundle.main.path(forResource: "/Audio/sound1", ofType: ".mp3")
        
        
        do {
            try musicEffect = AVAudioPlayer(contentsOf: URL(fileURLWithPath: musicFile!))
        }
        catch {
            print(error)
        }
        
        musicEffect.numberOfLoops = 5
        musicEffect.play()
    }
    

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
