//
//  recordSoundsViewController.swift
//  Pitch_Changer
//
//  Created by Noor Thabit on 6/28/15.
//  Copyright © 2015 Noor Thabit. All rights reserved.
//

import UIKit
import AVFoundation


class RecordViewController : UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingLable: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    
    
    var audioFile: AVAudioFile!
    
    var audioRecorder: AVAudioRecorder!

    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Landscape.rawValue)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recordingLable.hidden = false
        // Do any additional setup after loading the view, typically from a nib.
       
    }
    
    
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true
        recordingLable.text = "Tap to record!"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func recordVoice(sender: UIButton) {
        //TODO: record user's voice
        recordButton.enabled = false
        stopButton.hidden = false
        recordingLable.text = "Recording.."
        
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
        let recordingName = "myVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        
        let session = AVAudioSession.sharedInstance()

        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        session.overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker, error: nil)

        
        audioRecorder = AVAudioRecorder(URL: filePath!, settings: [String : AnyObject]() , error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    
    
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if(flag){
            audioFile = AVAudioFile(forReading: recorder.url, error: nil)
            self.performSegueWithIdentifier("stopRecording", sender: audioFile)
        } else {
            print("Recording was not complete")
            recordButton.enabled = true
            stopButton.hidden = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording"){
            let playSoundsVC:ChangeVoiceViewController = segue.destinationViewController as! ChangeVoiceViewController
            
            let data = sender as! AVAudioFile
            playSoundsVC.audioFile = data
        }
    }
    
    @IBAction func stop(sender: AnyObject) {
        stopButton.hidden = true
        recordingLable.text = "Processcing.."
        recordButton.enabled = true
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
}

