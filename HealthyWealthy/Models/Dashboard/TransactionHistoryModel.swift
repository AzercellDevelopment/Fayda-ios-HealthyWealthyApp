//
//  TransactionHistoryModel.swift
//  HealthyWealthy
//
//  Created by Aykhan Hajiyev on 23.01.22.
//

import Foundation

struct TransactionHistoryModel: Decodable {
    let data: [TransactionHistoryItem]
    let message: String
}

struct TransactionHistoryItem: Decodable {
    let createDate: String
    let description: String?
    let iconUrl: String
    let points: String
    let subtitle: String
    let title: String
    let type: String
}
