//
//  Target.swift
//  devtest
//
//  Created by darindra.khadifa on 17/05/23.
//

import Foundation

enum Target {
    case postEmployee(body: EmployeeRequest)
    case getEmployeeList
    case updateEmployee(id: Int, body: EmployeeRequest)
    case deleteEmployee(id: Int)
}

extension Target: TargetType {
    var path: String {
        switch self {
        case .postEmployee:
            return "/create"
        case .getEmployeeList:
            return "/employees"
        case let .updateEmployee(id, _):
            return "/update/\(id)"
        case let .deleteEmployee(id):
            return "/delete/\(id)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .postEmployee:
            return .post
        case .getEmployeeList:
            return .get
        case .updateEmployee:
            return .update
        case .deleteEmployee:
            return .delete
        }
    }

    var task: Task {
        switch self {
        case .postEmployee, .updateEmployee:
            return .requestData(parameters)
        case .deleteEmployee, .getEmployeeList:
            return .requestPlain
        }
    }

    var parameters: [String: Any] {
        switch self {
        case let .postEmployee(body):
            return [
                "name": body.name,
                "salary": body.salary,
                "age": body.age
            ]

        case let .updateEmployee(_, body):
            return [
                "name": body.name,
                "salary": body.salary,
                "age": body.age
            ]

        case .deleteEmployee, .getEmployeeList:
            return [:]
        }
    }
}
