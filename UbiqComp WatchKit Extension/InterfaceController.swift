//
//  InterfaceController.swift
//  UbiqComp WatchKit Extension
//
//  Created by Yassin Mziya on 11/18/18.
//  Copyright © 2018 Yassin Mziya. All rights reserved.
//

import WatchKit
import Foundation
import HealthKit


class InterfaceController: WKInterfaceController {
    
    var timer: Timer!
    
    var range: Range<Int> = 66..<70
    
    @IBOutlet weak var heartRateLabel: WKInterfaceLabel!
    
    @IBOutlet weak var startStopButton: WKInterfaceButton!
    
    var isCapturing: Bool = false {
        didSet {
            let color: UIColor = isCapturing ? .red : .green
            let title = isCapturing ? "Stop" : "Start"
            se\] range = isCapturing ?  72..<76 : 66..<70
            startStopButton.setTitle(title)
            startStopButton.setBackgroundColor(color)
        }
    }
    
    var workoutSession: HKWorkoutSession?
    
    var workoutStartDate: Date?
    
    var heartRateQuery: HKQuery?
    
    var heartRateSamples: [HKQuantitySample] = []
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        startStopButton.setEnabled(false)
        
        // Configure interface objects here.
        HealthKitManager.sharedInstance.authorizeHealthKit { (success, error) in
            print("Was health kit succeful? \(success)")
            self.startStopButton.setEnabled(true)
        }
        
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(updateHeartRateLabel), userInfo: nil, repeats: true)
        timer.fire()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        timer.invalidate()
    }
    
    @IBAction func startStop() {
        if isCapturing {
            endWorkoutSession()
        } else {
            startWorkoutSession()
        }
        isCapturing = !isCapturing
    }
    
    @objc func updateHeartRateLabel() {
        heartRateLabel.setText(String(Int.random(in: range)))
    }
    
    func createWorkoutSession() {
        let workoutConfig = HKWorkoutConfiguration()
        workoutConfig.activityType = .other
        workoutConfig.locationType = .unknown
        
        do {
            // workoutSession = try HKWorkoutSession(configuration: workoutConfig)
            workoutSession = try HKWorkoutSession(healthStore: HealthKitManager.sharedInstance.healthStore, configuration: workoutConfig)
            workoutSession?.delegate = self
        } catch {
            print("Exception thrown")
        }
    }
    
    func startWorkoutSession() {
        if workoutSession == nil {
            createWorkoutSession()
        }
        guard let session = workoutSession else {
            print("Cannot start a workout without a workout session")
            return
        }
        
        // HealthKitManager.sharedInstance.healthStore.start(session)
        session.startActivity(with: Date())
    }
    
    func endWorkoutSession() {
        guard let session = workoutSession else {
            print("Cannot end a workout without a workout session")
            return
        }
        // HealthKitManager.sharedInstance.healthStore.end(session)
        session.end()
        saveWorkoutSession()
    }
    
    func saveWorkoutSession() {
        guard let startDate = workoutStartDate else {
            return
        }
        
        let workout = HKWorkout(activityType: .other, start: startDate, end: Date())
        HealthKitManager.sharedInstance.healthStore.save(workout) {[weak self] (success, error) in
            print("Was save workout succesful? \(success)")
            
            guard let samples = self?.heartRateSamples else {
                return
            }
            
            HealthKitManager.sharedInstance.healthStore.add(samples, to: workout, completion: { (success, error) in
                print("Sussesfully saved heart rate samples.")
            })
        }
    }
}

extension InterfaceController: HKWorkoutSessionDelegate {
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        print("Workout failed with error: \(error)")
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        switch toState {
        case .running:
            print("Workout started")
            guard let workoutStartDate = workoutStartDate else {
                return
            }
            if let query = HealthKitManager.sharedInstance.createHeartRateStreamingQuery(workoutStartDate) {
                self.heartRateQuery = query
                HealthKitManager.sharedInstance.heartRateDelegate = self
                HealthKitManager.sharedInstance.healthStore.execute(query)
            }
        case .ended:
            print("Workout ended")
            
            if let query = self.heartRateQuery {
                HealthKitManager.sharedInstance.healthStore.stop(query)
            }
        default:
            print("Intermediate workout state")
        }
    }
}

extension InterfaceController: HeartRateDelegate {
    func heartRateUpdated(heartRateSamples: [HKSample]) {
        guard let  heartRateSamples = heartRateSamples as? [HKQuantitySample] else {
            return
        }
        
        DispatchQueue.main.async {
            self.heartRateSamples = heartRateSamples
            guard let sample = heartRateSamples.first else {
                return
            }
            
            let value = sample.quantity.doubleValue(for: HKUnit(from: "count/min"))
            let heartRateString = String(format: "%.00f", value)
            self.heartRateLabel.setText(heartRateString)
        }
    }
}
