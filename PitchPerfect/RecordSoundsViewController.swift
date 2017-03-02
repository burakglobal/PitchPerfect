//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by burakflatiron on 2/9/17.
//  Copyright © 2017 Burak Kebapci. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    var audioRecorder: AVAudioRecorder!

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopButton.isEnabled = false
        stopButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        recordButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
    }

    @IBAction func recordAudio(_ sender: Any) {
        setUIState(isRecording: true, recordingText: "Recording in Progress")
        
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        print(filePath!)
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
   
    func setUIState(isRecording:Bool, recordingText:String)
    {
        recordLabel.text = recordingText
       
        if (isRecording)
        {
            recordButton.isEnabled = false
            stopButton.isEnabled = true
            stopButton.isHidden = false
            recordButton.isHidden = true
        }
        else{
          
            stopButton.isEnabled = false
            recordButton.isEnabled = true
            stopButton.isHidden = true
            recordButton.isHidden = false
        }
    }
    
    
    @IBAction func stopAudio(_ sender: Any) {
        setUIState(isRecording: false, recordingText: " Tap to Record ")
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
    }
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
       // print("Finished Recording")
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
            
        } else {
            print("Recording Not Successful")
            recordLabel.text = " Recording Not Successful"
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL  = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
            
        }
    }

}

