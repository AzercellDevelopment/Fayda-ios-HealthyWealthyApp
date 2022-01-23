//
//  LoginParams.swift
//  HealthyWealthy
//
//  Created by Aykhan Hajiyev on 22.01.22.
//

import Foundation

struct LoginParams: Encodable {
    let email: String
    let password: String
}

struct LoginResponse: Decodable {
    let data: LoginResponseData
    let message: String
}

struct LoginResponseData: Decodable {
    let token: String
    let type: String
}

