//
//  MerchantsResponseModel.swift
//  HealthyWealthy
//
//  Created by Aykhan Hajiyev on 23.01.22.
//

import Foundation

struct MerchantsResponseModel: Decodable {
    let data: MerchantsData
    let message: String
}

struct MerchantsData: Decodable {
    let active: [MerchantsListItem]
    let nonActive: [MerchantsListItem]
}

struct MerchantsListItem: Decodable {
    let address: String?
    let calculatedTarif: String?
    let id: String?
    let latitude: Double
    let longitude: Double
    let name: String
    let startDate: String?
    let status: String?
    let stepCount: Int?
    let tarif: String
    let iconUrl: String
    let maxTarif: String
}

struct SingleMerchantResponseModel: Decodable {
    let data: String
    let message: String
}

struct SingleMerchantRequestModel: Encodable {
    let merchant_id: String
}
