//
//  SoundController.swift
//  MetalBreakOut
//
//  Created by Gabriel Lewis on 4/23/18.
//  Copyright © 2018 Gabriel Lewis. All rights reserved.
//

import AVFoundation

class SoundController {
    static let shared = SoundController()

    var popEffect: AVAudioPlayer?

    private init() {
        popEffect = preloadSoundEffect("pop.wav")
    }

    func preloadSoundEffect(_ fileName: String) -> AVAudioPlayer? {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: nil) else {
            return nil
        }
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
            return player
        } catch {
            print("file \(fileName) not found")
        }
        return nil
    }

    func playPopEffect() {
        popEffect?.play()
    }
}
