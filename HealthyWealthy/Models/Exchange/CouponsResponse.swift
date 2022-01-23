//
//  CouponsResponse.swift
//  HealthyWealthy
//
//  Created by Aykhan Hajiyev on 23.01.22.
//

import Foundation

struct CouponsResponse: Decodable {
    let data: [CouponsData]
    let message: String
}

struct CouponsData: Decodable {
    let description: String
    let iconUrl: String
    let id: String
    let price: Int
    let subtitle: String
    let title: String
}
