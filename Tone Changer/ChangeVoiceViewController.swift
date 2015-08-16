//
//  ChangeSoundViewController.swift
//  Pitch_Changer
//
//  Created by Noor Thabit on 6/29/15.
//  Copyright © 2015 Noor Thabit. All rights reserved.
//

import UIKit
import AVFoundation

class ChangeVoiceViewController: UIViewController {
    
    
    @IBOutlet weak var reset: UIButton!
    @IBOutlet weak var speedSlider: UISlider!
    @IBOutlet weak var pitchSlider: UISlider!
    @IBOutlet weak var stopButton: UIButton!
    
    var pitch: Float = 1.0
    var rate: Float = 1.0

    var audioEngine: AVAudioEngine!
    
    var audioFile: AVAudioFile!
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Landscape.rawValue)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioEngine = AVAudioEngine()
        
        print(audioFile.description)
       
    }
    
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true
        reset.hidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
        
    }
    
 
    
  
    
    @IBAction func reset(sender: UIButton) {
        audioEngine.stop()
        audioEngine.reset()
        rate = 1.0
        pitch = 1.0
        pitchSlider.value = 1.0
        speedSlider.value = 1.0
        pitchRateChanger()

    }
    
    func pitchRateChanger(){
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let pitchChangerNode  = AVAudioUnitTimePitch()
        
        pitchChangerNode.pitch = pitch
        pitchChangerNode.rate = rate

        audioEngine.attachNode(pitchChangerNode)
        
        audioEngine.connect(audioPlayerNode, to: pitchChangerNode, format: nil)
        
        audioEngine.connect(pitchChangerNode, to: audioEngine.outputNode, format: nil)
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
        stopButton.hidden = false
        
    }
    
    
    

    @IBAction func speedAdjust(sender: UISlider) {
        rate = sender.value
        audioEngine.stop()
        audioEngine.reset()
        pitchRateChanger()
        stopButton.hidden = false
        reset.hidden = false
        
    }
    
    @IBAction func pitchAdjust(sender: UISlider) {
        pitch = sender.value
        audioEngine.stop()
        audioEngine.reset()
        pitchRateChanger()
        stopButton.hidden = false
        reset.hidden = false


    }
    

    
    
    @IBAction func stop(sender: UIButton) {
        audioEngine.stop()
        stopButton.hidden = true
        
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
