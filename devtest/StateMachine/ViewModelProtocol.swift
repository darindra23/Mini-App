//
//  ViewModelProtocol.swift
//  devtest
//
//  Created by darindra.khadifa on 17/05/23.
//

import Foundation

public protocol InputProtocol<Action> {
    associatedtype Action

    var action: Observable<Action> { get }
    func send(_ event: Action)
}

public protocol OutputProtocol<State> {
    associatedtype State

    var state: Observable<State> { get }
}

public protocol ViewModelProtocol {
    associatedtype State
    associatedtype Action

    associatedtype Input: InputProtocol where Input.Action == Action
    associatedtype Output: OutputProtocol where Output.State == State

    var input: Input { get }
    var output: Output { get }

    func feedback(input: Action) -> Feedback<State, Action>
    func reduce(state: State, action: Action) -> State
}
