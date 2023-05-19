//
//  AddEditViewModel.swift
//  devtest
//
//  Created by darindra.khadifa on 18/05/23.
//

import Foundation

enum InputType: String, Equatable {
    case name
    case salary
    case age
}

enum PageType: Equatable {
    case add
    case edit(id: Int, data: Employee)
}

final class AddEditViewModel: ViewModelProtocol {
    enum State: Equatable {
        case initial
        case successSubmit
        case needInput(_ type: InputType)
        case error(NetworkError)
    }

    enum Action {
        // - MARK: Main Action
        case initial
        case didTapSubmitButton(data: EmployeeRequest)
        case didTapSeeAllButton

        // - MARK: Side Effect
        case showNeedInputAlert(_ type: InputType)
        case showSuccessAlert
        case showErrorAlert(NetworkError)
    }

    let input: Input = .init()
    let output: Output = .init()

    // - MARK: Data
    var requestBody: EmployeeRequest?
    var pageType: PageType

    @Injected(\.employeeRepo)
    var employeeRepo

    @Injected(\.route)
    var route

    init(pageType: PageType) {
        self.pageType = pageType

        if case let .edit(_, data) = pageType {
            requestBody = EmployeeRequest(
                name: data.name,
                salary: "\(data.salary)",
                age: "\(data.age)"
            )
        }

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
        Feedback<State, Action> { [pageType, employeeRepo, route] _, callback in
            switch input {
            case let .didTapSubmitButton(data):
                guard !data.name.isEmpty else {
                    callback(.showNeedInputAlert(.name))
                    return
                }

                guard !data.salary.isEmpty else {
                    callback(.showNeedInputAlert(.salary))
                    return
                }

                guard !data.age.isEmpty else {
                    callback(.showNeedInputAlert(.age))
                    return
                }

                switch pageType {
                case .add:
                    employeeRepo.createEmployee(with: data) { result in
                        switch result {
                        case .success:
                            callback(.showSuccessAlert)
                        case let .failure(error):
                            callback(.showErrorAlert(error))
                        }
                    }

                case let .edit(id, data):
                    let body = EmployeeRequest(
                        name: data.name,
                        salary: "\(data.salary)",
                        age: "\(data.age)"
                    )

                    employeeRepo.updateEmployee(id: id, body: body) { result in
                        switch result {
                        case .success:
                            callback(.showSuccessAlert)
                        case let .failure(error):
                            callback(.showErrorAlert(error))
                        }
                    }
                }

            case .didTapSeeAllButton:
                route(.employeeList)

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
        case let .showNeedInputAlert(type):
            return .needInput(type)

        case .showSuccessAlert:
            return .successSubmit

        case let .showErrorAlert(error):
            return .error(error)

        default:
            break
        }

        return state
    }
}

extension AddEditViewModel {
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
