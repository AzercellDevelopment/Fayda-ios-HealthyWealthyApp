//
//  NetworkManager.swift
//  HealthyWealthy
//
//  Created by Aykhan Hajiyev on 22.01.22.
//

import Foundation
import Alamofire

// MARK: - MAIN
class NetworkManager {
    static let shared = NetworkManager()
    private init() { }
    
    private let baseUrl = "https://stormy-shore-22838.herokuapp.com/"
    
    var header: HTTPHeaders {
        return [
            "Authorization": "Bearer \(APPDefaults.getString(key: DefaultsKey.token.rawValue) ?? "")"
        ]
    }
}


// MARK: - Login
extension NetworkManager {
    func login(with parameters: LoginParams, completion: @escaping (Swift.Result<LoginResponse, Error>) -> Void) {
        let url = baseUrl + "api/v1/auth/login/email"
        
        do {
            let data = try JSONEncoder().encode(parameters)
            guard let params = try JSONSerialization.jsonObject(with: data, options: []) as? Parameters else { fatalError() }
            
            Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
                
                DispatchQueue.main.async {
                    switch response.result {
                    case .failure(let error):
                        print("\(#function) Error: \(error)")
                        completion(.failure(error))
                    case .success:
                        do {
                            let data = try JSONDecoder().decode(LoginResponse.self, from: response.data!)
                            completion(.success(data))
                        } catch(let decoderError) {
                            print("\(#function) Error decoding response:\nError: \(decoderError)")
                            completion(.failure(decoderError))
                        }
                    }
                }
                
            }
            
        } catch(let encoderError) {
            completion(.failure(encoderError))
            print("\(#function) Error encoding data:\nError: \(encoderError)")
        }
    }
    
    func register(with parameters: LoginParams, completion: @escaping (Swift.Result<LoginResponse, Error>) -> Void) {
        let url = baseUrl + "api/v1/auth/register"
        
        do {
            let data = try JSONEncoder().encode(parameters)
            guard let params = try JSONSerialization.jsonObject(with: data, options: []) as? Parameters else { fatalError() }
            
            Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
                
                DispatchQueue.main.async {
                    switch response.result {
                    case .failure(let error):
                        print("\(#function) Error: \(error)")
                        completion(.failure(error))
                    case .success:
                        do {
                            let data = try JSONDecoder().decode(LoginResponse.self, from: response.data!)
                            completion(.success(data))
                        } catch(let decoderError) {
                            print("\(#function) Error decoding response:\nError: \(decoderError)")
                            completion(.failure(decoderError))
                        }
                    }
                }
                
            }
            
        } catch(let encoderError) {
            completion(.failure(encoderError))
            print("\(#function) Error encoding data:\nError: \(encoderError)")
        }
    }
}

// MARK: - Dashboard
extension NetworkManager {
    func postUserStepSync(with parameters: SyncPointsModel, completion: @escaping (Swift.Result<Int, Error>) -> Void) {
        let url = baseUrl + "api/v1/points/sync"
        
        do {
            let data = try JSONEncoder().encode(parameters)
            guard let params =  try JSONSerialization.jsonObject(with: data, options: []) as? Parameters else { fatalError() }
            
            Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: header).responseString { (response) in
                
                DispatchQueue.main.async {
                    switch response.result {
                    case .failure(let error):
                        print("\(#function) Error: \(error)")
                        completion(.failure(error))
                    case .success:
                        completion(.success(1))
                    }
                }
            }
        } catch(let encoderError) {
            completion(.failure(encoderError))
            print("\(#function) Error encoding data:\n Error: \(encoderError)")
        }
    }
    
    func getUserBalance(completion: @escaping (Swift.Result<UserBalanceResponseModel, Error>) -> Void) {
        let url = baseUrl + "api/v1/points/balance"
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            DispatchQueue.main.async {
                switch response.result {
                case .failure(let error):
                    print("\(#function) Error: \(error)")
                    completion(.failure(error))
                case .success:
                    do {
                        let data = try JSONDecoder().decode(UserBalanceResponseModel.self, from: response.data!)
                        completion(.success(data))
                    } catch(let decoderError) {
                        print("\(#function) Error decoding response:\nError: \(decoderError)")
                        completion(.failure(decoderError))
                    }
                }
            }
        }
    }
    
    func getUserHistory(completion: @escaping (Swift.Result<TransactionHistoryModel, Error>) -> Void) {
        let url = baseUrl + "api/v1/points/history"
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            DispatchQueue.main.async {
                switch response.result {
                case .failure(let error):
                    print("\(#function) Error: \(error)")
                    completion(.failure(error))
                case .success:
                    do {
                        let data = try JSONDecoder().decode(TransactionHistoryModel.self, from: response.data!)
                        completion(.success(data))
                    } catch(let decoderError) {
                        print("\(#function) Error decoding response:\nError: \(decoderError)")
                        completion(.failure(decoderError))
                    }
                }
            }
        }
    }
}

// MARK: - Merchants
extension NetworkManager {
    func getMerchants(completion: @escaping (Swift.Result<MerchantsResponseModel, Error>) -> Void) {
        let url = baseUrl + "api/v1/merchant/all"
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            switch response.result {
            case .failure(let error):
                print("\(#function) Error: \(error)")
                completion(.failure(error))
            case .success:
                do {
                    let data = try JSONDecoder().decode(MerchantsResponseModel.self, from: response.data!)
                    completion(.success(data))
                } catch(let decoderError) {
                    print("\(#function) Error decoding response:\nError: \(decoderError)")
                    completion(.failure(decoderError))
                }
            }
        }
    }
    
    func cancelMerchant(completion: @escaping (Swift.Result<SingleMerchantResponseModel, Error>) -> Void) {
        let url = baseUrl + "api/v1/merchant/cancel"
        
        Alamofire.request(url, method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            DispatchQueue.main.async {
                switch response.result {
                case .failure(let error):
                    print("\(#function) Error: \(error)")
                    completion(.failure(error))
                case .success:
                    do {
                        let data = try JSONDecoder().decode(SingleMerchantResponseModel.self, from: response.data!)
                        completion(.success(data))
                        
                    } catch(let decoderError) {
                        print("\(#function) Error decoding response:\nError: \(decoderError)")
                        completion(.failure(decoderError))
                    }
                }
            }
        }
    }
    
    func startMerchant(merchantId: String, completion: @escaping (Swift.Result<SingleMerchantResponseModel, Error>) -> Void) {
        let url = baseUrl + "api/v1/merchant/start?merchant_id=\(merchantId)"
        
        Alamofire.request(url, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            DispatchQueue.main.async {
                switch response.result {
                case .failure(let error):
                    print("\(#function) Error: \(error)")
                    completion(.failure(error))
                case .success:
                    do {
                        let data = try JSONDecoder().decode(SingleMerchantResponseModel.self, from: response.data!)
                        completion(.success(data))
                    } catch(let decoderError) {
                        print("\(#function) Error decoding response:\nError: \(decoderError)")
                        completion(.failure(decoderError))
                    }
                }
            }
        }
    }
}

// MARK: - Exchange

extension NetworkManager {
    func getCouponsList(completion: @escaping (Swift.Result<CouponsResponse, Error>) -> Void) {
        let url = baseUrl + "api/v1/coupons"
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            DispatchQueue.main.async {
                switch response.result {
                case .failure(let error):
                    print("\(#function) Error: \(error)")
                    completion(.failure(error))
                case .success:
                    do {
                        let data = try JSONDecoder().decode(CouponsResponse.self, from: response.data!)
                        completion(.success(data))
                    } catch(let decoderError) {
                        print("\(#function) Error decoding response:\nError: \(decoderError)")
                        completion(.failure(decoderError))
                    }
                }
            }
        }
    }
    
    func buyCoupon(couponId: String, completion: @escaping (Swift.Result<SingleMerchantResponseModel, Error>) -> Void) {
        let url = baseUrl + "api/v1/coupons/buy?coupon_id=\(couponId)"
        
        Alamofire.request(url, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            DispatchQueue.main.async {
                switch response.result {
                case .failure(let error):
                    print("\(#function) Error: \(error)")
                    completion(.failure(error))
                case .success:
                    do {
                        let data = try JSONDecoder().decode(SingleMerchantResponseModel.self, from: response.data!)
                        completion(.success(data))
                    } catch(let decoderError) {
                        print("\(#function) Error decoding response:\nError: \(decoderError)")
                        completion(.failure(decoderError))
                    }
                }
            }
        }
    }
}
