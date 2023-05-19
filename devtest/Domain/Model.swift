//
//  Model.swift
//  devtest
//
//  Created by darindra.khadifa on 17/05/23.
//

import Foundation

struct EmployeeResponse: Decodable, Equatable {
    let data: [Employee]
}

struct Employee: Decodable, Equatable {
    let id: Int
    let name: String
    let salary: Int
    let age: Int

    enum CodingKeys: String, CodingKey {
        case id
        case name = "employee_name"
        case salary = "employee_salary"
        case age = "employee_age"
    }
}

struct EmployeeRequest: Equatable {
    let name: String
    let salary: String
    let age: String
}
