//
//  Router.swift
//  devtest
//
//  Created by darindra.khadifa on 19/05/23.
//

import UIKit

enum Route {
    case employeeList
    case addEditEmployee(pageType: PageType)
}

final class Router {
    static func navigateTo(_ route: Route) {
        routeHandler(route)
    }

    static func push(_ viewController: UIViewController) {
        guard let topViewController = UIApplication.topViewController() else { return }
        topViewController.navigationController?.pushViewController(viewController, animated: true)
    }

    static func present(_ viewController: UIViewController) {
        guard let topViewController = UIApplication.topViewController() else { return }
        topViewController.present(viewController, animated: true)
    }

    private static func routeHandler(_ route: Route) {
        let viewController: UIViewController

        switch route {
        case .employeeList:
            viewController = EmployeeListViewController()

            push(viewController)

        case let .addEditEmployee(pageType):
            let viewModel = AddEditViewModel(pageType: pageType)
            viewController = AddEditViewController(viewModel: viewModel)

            push(viewController)
        }
    }
}

private struct RouteProvider: InjectionKey {
    static var currentValue: (Route) -> Void = { route in
        Router.navigateTo(route)
    }
}

extension InjectedValues {
    var route: (Route) -> Void {
        get { Self[RouteProvider.self] }
        set { Self[RouteProvider.self] = newValue }
    }
}
