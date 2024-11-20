//
//  SoundPlayer.swift
//  WeaponFiringSimulator
//
//  Created by ウルトラ深瀬 on 20/11/24.
//

import AudioToolbox

protocol SoundPlayerInterface {
    func play(_ sound: SoundType)
}

struct SoundPlayer {
    static let shared = SoundPlayer()
    private var systemSoundIds = [SoundType: SystemSoundID]()
    
    // インスタンスは1つしか必要ないので増やせないように制限
    private init() {
        SoundType.allCases.forEach { sound in
            guard let soundUrl = Bundle.main.url(forResource: sound.rawValue, withExtension: "mp3") else {
                print("音源\(sound.rawValue)が見つかりません")
                return
            }
            // idはinout引数でシステムが自動で割り当てるため、可変なSystemSoundIDのインスタンスを作成
            var soundId = SystemSoundID()
            
            // 音源のURLをSystemSoundIDに割り当て
            AudioServicesCreateSystemSoundID(soundUrl as CFURL, &soundId)
            
            // システムによって割り当てられた（inout引数で変更された）idを辞書に保持
            systemSoundIds[sound] = soundId
        }
    }
}

extension SoundPlayer: SoundPlayerInterface {
    func play(_ sound: SoundType) {
        guard let soundId = systemSoundIds[sound] else {
            print("\(sound)に対応するSystemSoundIDが見つかりません")
            return
        }
        // 効果音の再生
        AudioServicesPlaySystemSound(soundId)
        
        // バイブレーションの実行
        if sound.needsPlayVibration {
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
    }
}
