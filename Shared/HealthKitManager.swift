//
//  HealthKitManager.swift
//  UbiqComp WatchKit Extension
//
//  Created by Yassin Mziya on 11/27/18.
//  Copyright © 2018 Yassin Mziya. All rights reserved.
//

import Foundation
import HealthKit

protocol HeartRateDelegate {
    func heartRateUpdated(heartRateSamples: [HKSample])
}

class HealthKitManager: NSObject {
    static let sharedInstance = HealthKitManager()
    
    let healthStore = HKHealthStore()
    
    var anchor: HKQueryAnchor?
    
    var heartRateDelegate: HeartRateDelegate?
    
    private override init() {}
    
    func authorizeHealthKit(_ completion: @escaping ((_ success: Bool, _ error: Error?) -> Void)) {
        guard let heartRateType: HKQuantityType = HKQuantityType.quantityType(forIdentifier: .heartRate) else {
            return
        }
        let typeToShare = Set([HKObjectType.workoutType(), heartRateType])
        let typeToRead = Set([HKObjectType.workoutType(), heartRateType])
        healthStore.requestAuthorization(toShare: typeToShare, read: typeToRead) { (success, error) in
            completion(success, error)
        }
    }
    
    func createHeartRateStreamingQuery(_ workoutStartDate: Date) -> HKQuery? {
        guard let heartRateType: HKQuantityType = HKQuantityType.quantityType(forIdentifier: .heartRate) else {
            return nil
        }
        
        let datePredicate = HKQuery.predicateForSamples(withStart: workoutStartDate, end: nil, options: .strictEndDate)
        let compoundPredicte = NSCompoundPredicate(andPredicateWithSubpredicates: [datePredicate])
        
        let hearRateQuery = HKAnchoredObjectQuery(type: heartRateType, predicate: compoundPredicte, anchor: nil, limit: Int(HKObjectQueryNoLimit)) { (query, sampleObjects, deletedObjects, newAnchor, error) in
            guard let newAnchor = newAnchor, let sampleObjects = sampleObjects else {
                return
            }
            self.anchor = newAnchor
            self.heartRateDelegate?.heartRateUpdated(heartRateSamples: sampleObjects)
        }
        
        hearRateQuery.updateHandler = {(query, sampleObjects, deletedObjects, newAnchor, error) -> Void in
            guard let newAnchor = newAnchor, let sampleObjects = sampleObjects else {
                return
            }
            self.anchor = newAnchor
            self.heartRateDelegate?.heartRateUpdated(heartRateSamples: sampleObjects)
        }
        return hearRateQuery
    }
}
