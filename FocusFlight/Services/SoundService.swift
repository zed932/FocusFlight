//
//  SoundService.swift
//  FocusFlight
//
//  Created by Сергей Мещеряков on 16.01.2026.
//


import AVFoundation

class SoundService {
    
    var cabinPlayer: AVAudioPlayer?
    var beltPlayer: AVAudioPlayer?
    
    init() {
        setupAudioSession()
    }
    
    func setupAudioSession() {
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to setup audio session: \(error)")
        }
        
    }
    
    func playBeltSound(named filename: String, withExtension: String = "mp3") {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "mp3") else {
            print("Belt sound not found")
            return
        }
        
        do {
            beltPlayer = try AVAudioPlayer(contentsOf: url)
            beltPlayer?.play()
        } catch {
            print("Playback belt error")
        }
    }
    
    func playingLoopCabinSound(named filename: String) {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "mp3") else {
            print("cabin_no_people sound not found")
            return
        }
        
        do {
            cabinPlayer = try AVAudioPlayer(contentsOf: url)
            cabinPlayer?.numberOfLoops = -1
            cabinPlayer?.play()
        } catch {
            print("Playback cabin error")
        }
    }
    
    func stop() {
        cabinPlayer?.stop()
        beltPlayer?.stop()
        cabinPlayer = nil
        beltPlayer = nil
    }
    
}
