//
//  SyncPointsModel.swift
//  HealthyWealthy
//
//  Created by Aykhan Hajiyev on 22.01.22.
//

import Foundation

struct SyncPointsModel: Encodable {
    let points: Int
}

struct SyncPointsResponseModel: Decodable {
    let points: Int
}

struct UserBalanceResponseModel: Decodable {
    let data: UserBalanceResponseData
    let message: String
}

struct UserBalanceResponseData: Decodable {
    let balance: Int
    let lastSyncDate: String
    let refNum: String
}
