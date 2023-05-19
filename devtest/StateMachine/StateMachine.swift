//
//  StateMachine.swift
//  devtest
//
//  Created by darindra.khadifa on 17/05/23.
//

import Foundation

public struct Feedback<State, Action> {
    var run: (_ state: State, _ callback: @escaping (Action) -> Void) -> Void

    public init(run: @escaping (State, @escaping (Action) -> Void) -> Void) {
        self.run = run
    }
}

public final class StateMachine<State, Action> {
    public private(set) var state: Observable<State>
    public private(set) var action: Observable<Action>

    public convenience init(
        initial: (state: State, action: Action),
        reduce: @escaping (State, Action) -> State,
        feedbacks: ((Action) -> Feedback<State, Action>)...
    ) {
        self.init(initial: initial, reduce: reduce, feedbacks: feedbacks)
    }

    public init(
        initial: (state: State, action: Action),
        reduce: @escaping (State, Action) -> State,
        feedbacks: [(Action) -> Feedback<State, Action>]
    ) {
        state = Observable<State>(initial.state)
        action = Observable<Action>(initial.action)

        action.bindAndFire { action in
            for feedback in feedbacks {
                feedback(action).run(self.state.value) { newAction in
                    let newState = reduce(self.state.value, newAction)
                    self.state.value = newState
                }
            }
        }
    }
}
