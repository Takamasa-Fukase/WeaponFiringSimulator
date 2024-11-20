//
//  SoundPlayer2.swift
//  WeaponFiringSimulator
//
//  Created by ウルトラ深瀬 on 20/11/24.
//

import AudioToolbox

struct SoundPlayer2 {
    private var systemSoundIds = [SoundType: SystemSoundID]()
    
    init() {
        SoundType.allCases.forEach { sound in
            guard let soundUrl = Bundle.main.url(forResource: sound.rawValue, withExtension: "mp3") else {
                print("音源\(sound.rawValue)が見つかりません")
                return
            }
            // idはinout引数でシステムが自動で割り当てるため、可変なSystemSoundIDのインスタンスを作成して渡す
            var soundId: SystemSoundID = 0
            
            // 音源のURLをSystemSoundIDに割り当て
            AudioServicesCreateSystemSoundID(soundUrl as CFURL, &soundId)
            
            // システムによって割り当てられた（inout引数で変更された）idを辞書に保持
            systemSoundIds[sound] = soundId
        }
    }
}

extension SoundPlayer2: SoundPlayerInterface {
    func play(_ sound: SoundType) {
        guard let soundId = systemSoundIds[sound] else {
            print("\(sound)に対応するSystemSoundIDが見つかりません")
            return
        }
        AudioServicesPlaySystemSound(soundId)
    }
}
