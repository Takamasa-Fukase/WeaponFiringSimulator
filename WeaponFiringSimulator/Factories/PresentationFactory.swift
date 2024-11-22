//
//  PresentationFactory.swift
//
//
//  Created by ウルトラ深瀬 on 22/11/24.
//

import UIKit

public final class PresentationFactory {
    public static func createMainViewController() -> ViewController {
        let vc = UIStoryboard(name: "ViewController", bundle: Bundle.main).instantiateInitialViewController() as! ViewController
        let presenter = Presenter(
            view: vc,
            weaponResourceGetUseCase: UseCaseFactory.create(),
            weaponActionExecuteUseCase: UseCaseFactory.create()
        )
        vc.inject(
            soundPlayer: createSoundPlayer(),
            presenter: presenter
        )
        return vc
    }
    
    // MARK: Private Methods
    
    private static func createSoundPlayer() -> SoundPlayerInterface {
        return SoundPlayer()
    }
}
