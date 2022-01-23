//
//  CoreMotionHelper.swift
//  HealthyWealthy
//
//  Created by Aykhan Hajiyev on 22.01.22.
//

import Foundation
import CoreMotion

enum UserActivityState: Int {
    case stationary = 1
    case walking = 2
    case running = 3
}

class CoreMotionHelper {
    static let shared = CoreMotionHelper()
    
    private let activityManager = CMMotionActivityManager()
    private let pedometer = CMPedometer()
    
    private init() { }
    
    func getUserStepCount(completion: @escaping ((Int) -> Void)) {
        if let startDateString = APPDefaults.getString(key: DefaultsKey.lastSyncDate.rawValue) {
            let start = DateTimeHelper().convertStringToDate(dateString: startDateString) ?? Date()
            let end = Date()
            pedometer.queryPedometerData(from: start, to: end) { pedoMeter, error in
                completion(pedoMeter?.numberOfSteps.intValue ?? 0)
            }
        } else {
            completion(0)
        }
    }
    
    func getUserActivity(completion: @escaping (UserActivityState)-> Void) {
        activityManager.startActivityUpdates(to: OperationQueue.main) { (activity: CMMotionActivity?) in
            guard let activity = activity else {
                return
            }
            
            DispatchQueue.main.async {
                if activity.stationary {
                    completion(.stationary)
                } else if activity.running {
                    completion(.running)
                } else if activity.walking {
                    completion(.walking)
                }
            }
        }
    }
    
}
