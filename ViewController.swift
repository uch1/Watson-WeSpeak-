//
//  ViewController.swift
//  Watson Speaks
//
//  Created by Alick C Zhang on 7/8/17.
//  Copyright © 2017 Alick C Zhang. All rights reserved.
//

import UIKit
import SpeechToTextV1
import AVFoundation
import LanguageTranslatorV2

class ViewController: UIViewController {
    
    
    @IBOutlet weak var transcribedLabel: UITextField!
    
    @IBOutlet weak var originalTextView: UITextField!

    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var speechToText: SpeechToText?
    var isRecording = false
    @IBAction func updateTranslation(_ sender: Any) {
        self.translate()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        speechToText = SpeechToText(username: Constants.SpeechToText.username, password: Constants.SpeechToText.password)
        
        
    }
    // Do any additional setup after loading the view, typically from a nib.
    
    @IBAction func startstopRecording(_ sender: Any) {
        if isRecording {
            
            stopStreaming()
            self.isRecording = false
            translate()
            
            
        } else {
            startStreaming()
            self.isRecording = true
        }
    }
    
    func translate() {
        callTranslation(toTranslate: originalTextView.text!)
        while (!Constants.Global.hasChanged) {}
        transcribedLabel.text = Constants.Global.translatedText
    }
    
    
    func startStreaming() {
        var settings = RecognitionSettings(contentType: .opus)
        settings.continuous = true
        settings.interimResults = true
        let failure = { (error: Error) in print(error)
            
        }
        
        speechToText?.recognizeMicrophone(settings: settings, failure: failure) { results in
            self.originalTextView.text = results.bestTranscript
            
        }
    }
    
    func stopStreaming() {
        speechToText?.stopRecognizeMicrophone()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func callTranslation(toTranslate: String) {
        var language = "es"
        switch self.segmentedControl.selectedSegmentIndex {
        case 0:
            language = "es"
        case 1:
            language = "fr"
        case 2:
            language = "it"
        default:
            break
            
        }
        let languageTranslator = LanguageTranslator(username: Constants.LanguageTranslator.username, password: Constants.LanguageTranslator.password)
        let failure = { (error: Error) in print(error) }
        languageTranslator.translate(toTranslate, from: "en", to: language, failure: failure) { translation in
            Constants.Global.translatedText = translation.translations[0].translation
            Constants.Global.hasChanged = true
        }
        
    }
//    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        self.yourTextView.setContentOffset(CGPoint.zero, animated: false)
//    }
}





