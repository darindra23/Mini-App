//
//  UIApplication+Extension.swift
//  devtest
//
//  Created by darindra.khadifa on 18/05/23.
//

import UIKit

extension UIApplication {
    private static func topViewController(_ base: UIViewController?) -> UIViewController? {
        if let search = base as? UISearchController {
            return search.presentingViewController
        }

        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }

        if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return topViewController(selected)
        }

        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }

        return base
    }

    internal static func topViewController() -> UIViewController? {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            let window = scene.windows.first(where: { $0.isKeyWindow })
            return topViewController(window?.rootViewController)
        }
        return nil
    }
}

