//
//  UseCase.swift
//  devtest
//
//  Created by darindra.khadifa on 17/05/23.
//

import Foundation

typealias ListResult = Result<EmployeeResponse, NetworkError>

protocol EmployeeRepo {
    func createEmployee(with body: EmployeeRequest, _ completion: @escaping (Result<Data, NetworkError>) -> Void)
    func getEmployee(_ completion: @escaping (ListResult) -> Void)
    func updateEmployee(id: Int, body: EmployeeRequest, _ completion: @escaping (Result<Data, NetworkError>) -> Void)
    func deleteEmployee(id: Int, _ completion: @escaping (Result<Data, NetworkError>) -> Void)
}

struct EmployeeRepository: EmployeeRepo {
    func getEmployee(_ completion: @escaping (ListResult) -> Void) {
        APIManager.shared.request(Target.getEmployeeList) { result in
            let decodedResult = result.decodeResult(EmployeeResponse.self)
            completion(decodedResult)
        }
    }

    func updateEmployee(id: Int, body: EmployeeRequest, _ completion: @escaping (Result<Data, NetworkError>) -> Void) {
        APIManager.shared.request(Target.updateEmployee(id: id, body: body), completion: completion)
    }

    func createEmployee(with body: EmployeeRequest, _ completion: @escaping (Result<Data, NetworkError>) -> Void) {
        APIManager.shared.request(Target.postEmployee(body: body), completion: completion)
    }

    func deleteEmployee(id: Int, _ completion: @escaping (Result<Data, NetworkError>) -> Void) {
        APIManager.shared.request(Target.deleteEmployee(id: id), completion: completion)
    }
}

private struct EmployeeRepoProvider: InjectionKey {
    static var currentValue: EmployeeRepo = EmployeeRepository()
}

extension InjectedValues {
    var employeeRepo: EmployeeRepo {
        get { Self[EmployeeRepoProvider.self] }
        set { Self[EmployeeRepoProvider.self] = newValue }
    }
}
