//
//  EmployeeListViewModel.swift
//  devtest
//
//  Created by darindra.khadifa on 17/05/23.
//

import Foundation

final class EmployeeListViewModel: ViewModelProtocol {
    enum State {
        case initial
        case reloadTable
        case successRemove
        case error(NetworkError)
    }

    enum Action {
        // - MARK: Main Action
        case initial
        case didLoad

        // - MARK: Child Action
        case cellAction(at: IndexPath, action: CellAction)

        // - MARK: Side Effect
        case receiveData
        case removeEmployee
        case showErrorAlert(NetworkError)
    }

    let input: Input = .init()
    let output: Output = .init()

    var employees = [Employee]()

    @Injected(\.employeeRepo)
    var employeeRepo: EmployeeRepo

    @Injected(\.route)
    var route

    init() {
        let machine = StateMachine<State, Action>(
            initial: (State.initial, Action.initial),
            reduce: reduce,
            feedbacks: feedback
        )

        machine.state.bindAndFire { newState in
            self.output.state.value = newState
        }

        input.action.bind { input in
            machine.action.value = input
        }
    }

    /// Side effect occur, e.g. Fetch data from network
    /// - Parameter input: Action provided by UI
    /// - Returns: New action after side effect
    internal func feedback(input: Action) -> Feedback<State, Action> {
        Feedback<State, Action> { [employeeRepo] _, callback in
            switch input {
            case .didLoad:
                employeeRepo.getEmployee { result in
                    switch result {
                    case let .success(response):
                        self.employees = response.data
                        callback(.receiveData)

                    case let .failure(error):
                        callback(.showErrorAlert(error))
                    }
                }

            case let .cellAction(indexPath, action):
                let employee = self.employees[indexPath.row]

                switch action {
                case .didTapEdit:
                    let pageType = PageType.edit(id: employee.id, data: employee)
                    self.route(.addEditEmployee(pageType: pageType))

                case .didTapDelete:
                    self.employees.remove(at: indexPath.row)

                    employeeRepo.deleteEmployee(id: employee.id) { result in
                        switch result {
                        case .success:
                            callback(.removeEmployee)
                        case let .failure(error):
                            callback(.showErrorAlert(error))
                        }
                    }
                }

            default:
                return
            }
        }
    }

    /// Generate new state
    /// - Parameters:
    ///   - state: UI state
    ///   - action: Callback action
    /// - Returns: New state
    internal func reduce(state: State, action: Action) -> State {
        switch action {
        case .receiveData:
            return .reloadTable

        case .removeEmployee:
            return .successRemove

        case let .showErrorAlert(error):
            return .error(error)

        default:
            break
        }
        return state
    }
}

extension EmployeeListViewModel {
    internal class Input: InputProtocol {
        var action: Observable<Action> = .init(.initial)
        func send(_ action: Action) {
            self.action.value = action
        }
    }

    internal class Output: OutputProtocol {
        var state: Observable<State> = .init(.initial)
    }
}
