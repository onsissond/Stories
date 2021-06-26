//
//  Created by onsissond.
//

import UIKit
import Stories

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        window?.rootViewController = StoriesFactory.create(dependency: .init(
            dateProvider: { Date.mock("2021-03-28", dateFormat: "yyyy-MM-dd")! },
            openURL: { UIApplication.shared.open($0) } 
        ), payload: Void())
        window?.makeKeyAndVisible()
    }
}

