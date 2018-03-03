//
//  ViewController.swift
//  SpeechWorks
//
//  Created by Akshay Ayyanchira on 3/2/18.
//  Copyright © 2018 Akshay Ayyanchira. All rights reserved.
//

import UIKit
import Speech
import Alamofire


class ViewController: UIViewController,SFSpeechRecognizerDelegate {
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask:SFSpeechRecognitionTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if SFSpeechRecognizer.authorizationStatus() == SFSpeechRecognizerAuthorizationStatus.notDetermined{
            requestPermissionForSpeech()
            
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func recordSpeechButtonPressed(_ sender: UIButton) {
        recordAndRecognizeSpeech()
        
    }
    func recordAndRecognizeSpeech(){
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, time) in
            self.request.append(buffer)
        }
        audioEngine.prepare()
        do{
            try audioEngine.start()
        }catch{
            return print(error)
        }
        
        guard let myRecognizer = SFSpeechRecognizer() else {
            return
        }
        
        if !myRecognizer.isAvailable{
            // Recognizer not avaiable.
            return
        }
        
        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { (result, error) in
            if let result = result{
                let obtainedString = result.bestTranscription.formattedString
                print(obtainedString)
            }else if let error = error{
                print(error)
            }
        })
    }
    
    
    func requestPermissionForSpeech(){
        SFSpeechRecognizer.requestAuthorization { authStatus in
            /* The callback may not be called on the main thread. Add an
             operation to the main queue to update the record button's state.
             */
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
//                    self.recordButton.isEnabled = true
                    print("Granted")
                case .denied:
                    print("Denied")
//                    self.recordButton.isEnabled = false
//                    self.recordButton.setTitle("User denied access to speech recognition", for: .disabled)
                case .restricted:
                    print("Restriced")
//                    self.recordButton.isEnabled = false
//                    self.recordButton.setTitle("Speech recognition restricted on this device", for: .disabled)
                case .notDetermined:
                    print("Not Determined")
//                    self.recordButton.isEnabled = false
//                    self.recordButton.setTitle("Speech recognition not yet authorized", for: .disabled)
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

