//
//  Item.swift
//  BLETest
//
//  Created by Emily Sun on 9/20/25.
//

import Foundation
import SwiftData
import SwiftUI
import Combine

final class DataPoint: Identifiable {
    let id = UUID()
    var x: Double
    let y: Double
    
    init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
}

final class MyData: ObservableObject {
    @Published var coords: [DataPoint] = [DataPoint(x: 0.0, y: 0.0)]
    
    func noisySine(x: Double, noiseAmplitude: Double = 0.2) -> Double {
        let noise = Double.random(in: -noiseAmplitude...noiseAmplitude)
        return pow(sin(x), 2) + noise
    }
    
    func clearData() {
        self.coords.removeAll()
    }
}

class SharedModel: ObservableObject {
    @Published var myData = MyData()
    @Published var timer: Timer?
    @Published var isRunning = false
    @Published var counter = 0.0
    @Published var frequency: Double = 1
    @Published var frequencies: [Double] = [1, 2, 5, 10, 20]
    @Published var format = "displacement"
    @Published var formats: [String] = ["displacement", "velocity", "acceleration", "jerk"]

    func genData(type: String) -> Double {
        let y = self.myData.noisySine(x: self.counter, noiseAmplitude: 0.3)
        if type == "displacement" {
            return y
        } else if type == "velocity" {
            let coord1 = self.myData.coords.last
            let coord1x = coord1?.x
            let coord1y = coord1?.y
            let ynew: Double?
            if let a = coord1x, let b = coord1y {
                ynew = (y - b)/(self.counter - a)
                return ynew!
            } else {
                return 0.0
            }
        }
        return 0.0
    }
    
    func startTimer() {
        stopTimer()
        let interval = 1 / self.frequency
        self.timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            self.counter += interval
            let y = self.genData(type: self.format)
            let point = DataPoint(x: self.counter, y: y)
            self.myData.coords.append(point)
            self.isRunning = true
        }
    }
            
    func stopTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    /*
    func changeFrequency(to newFrequency: Double) {
        self.frequency = newFrequency
        startTimer()
    }
    */
    func saveCoordsToFile() {
        let csv = self.myData.coords.map { "\($0.x),\($0.y)"}.joined(separator: "\n")
        
        if let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documents.appendingPathComponent("history.csv")
            
            do {
                try csv.write(to: fileURL, atomically: true, encoding: .utf8)
            } catch {
                print("Failed to write to file: \(error)")
            }
        }
    }
}
