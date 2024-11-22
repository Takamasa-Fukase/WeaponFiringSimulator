//
//  ViewControllerFactory.swift
//
//
//  Created by ウルトラ深瀬 on 22/11/24.
//

import UIKit
import Presentation

struct ViewControllerFactory {
    static func create() -> ViewController {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.presentation).instantiateInitialViewController() as! ViewController
        let presenter = Presenter(
            view: vc,
            weaponResourceGetUseCase: UseCaseFactory.create(),
            weaponActionExecuteUseCase: UseCaseFactory.create()
        )
        vc.inject(
            soundPlayer: SoundPlayer(),
            presenter: presenter
        )
        return vc
    }
}
