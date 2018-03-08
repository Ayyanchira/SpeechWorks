//
//  LoadAudioViewController.swift
//  SpeechWorks
//
//  Created by Akshay Ayyanchira on 3/6/18.
//  Copyright © 2018 Akshay Ayyanchira. All rights reserved.
//

import UIKit
import AVFoundation
import Speech

class LoadAudioViewController: UIViewController {
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    var player: AVAudioPlayer?
    var countOfWords = 0
    @IBOutlet weak var textView: UITextView!
    var storyText:NSMutableAttributedString = NSMutableAttributedString(string: "Good morning have a nice day today is Saturday and hope this application looks good")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.attributedText = storyText
//        let storyWords = storyText.string.components(separatedBy: CharacterSet(charactersIn: " "))
        
    }

    
    
    var highlightingText:String = "" {
        
        willSet (newWord){
            if highlightingText != newWord{
                self.highlightingText = newWord
                //call function to highlight next word after this word.
                let range = (storyText.string as NSString).range(of: newWord)
                storyText.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range: range)
                textView.attributedText = storyText
            }
        }
        
        
    }
    @IBAction func play(_ sender: UIButton){

        let fileURL = URL(fileURLWithPath: Bundle.main.path(forResource: "App test", ofType: ".wav")!)
        let request = SFSpeechURLRecognitionRequest(url: fileURL)
        speechRecognizer?.recognitionTask(with: request, resultHandler: { (result, error) in
            let newWord = result?.bestTranscription.segments.last
            self.highlightingText = (newWord?.substring)!
            print(newWord?.substring)
//            print(result?.bestTranscription.formattedString)
        })
        
        if let asset = NSDataAsset(name:"App test"){
            
            do {
                // Use NSDataAsset's data property to access the audio file stored in Sound.
                player = try AVAudioPlayer(data:asset.data, fileTypeHint:"wav")
                // Play the above sound file.
                player?.play()
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }


}
