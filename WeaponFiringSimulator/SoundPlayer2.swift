//
//  SoundPlayer2.swift
//  WeaponFiringSimulator
//
//  Created by ウルトラ深瀬 on 20/11/24.
//

import AudioToolbox

final class SoundPlayer2 {
    private var systemSoundIds = [SoundType: SystemSoundID]()
    
    init() {
        SoundType.allCases.forEach { sound in
            if let soundUrl = Bundle.main.url(forResource: sound.rawValue, withExtension: "mp3") {
                var soundId: SystemSoundID = 0
                print("AudioServicesCreateSystemSoundID for \(sound), id: \(soundId)")
                let result = AudioServicesCreateSystemSoundID(soundUrl as CFURL, &soundId)
                systemSoundIds[sound] = soundId
                print("result: \(result), id: \(soundId)")
            }else {
                print("読み込み失敗")
            }
        }
    }
}

extension SoundPlayer2: SoundPlayerInterface {
    func play(_ sound: SoundType) {
        guard let soundId = systemSoundIds[sound] else {
            print("playSound soundIdが見つかりません \(sound)")
            return
        }
        AudioServicesPlaySystemSound(soundId)
    }
}
