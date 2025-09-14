//
//  HealthManager.swift
//  Runner
//
//  Created by Thien Huynh on 14/9/25.
//

import Foundation
import HealthKit

class HealthManager {
    let healthStore = HKHealthStore()
    
    /// request permission
    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        let typesToRead: Set<HKObjectType> = [
            HKObjectType.quantityType(forIdentifier: .stepCount)!
        ]
        
        healthStore.requestAuthorization(
            toShare: nil,
            read: typesToRead,
            completion: completion
        )
    }
    
    /// fetch today steps
    func fetchSteps(completion: @escaping (Double?, Error?) -> Void) {
        guard let stepsType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            completion(nil, nil)
            return
        }
        
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: stepsType,
                                      quantitySamplePredicate: predicate,
                                      options: .cumulativeSum) { _, result, error in
            if let sum = result?.sumQuantity() {
                completion(sum.doubleValue(for: HKUnit.count()), nil)
            } else {
                completion(nil, error)
            }
        }
        
        healthStore.execute(query)
    }
}
