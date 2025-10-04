//
//  BLETestApp.swift
//  BLETest
//
//  Created by Emily Sun on 9/20/25.
//

import SwiftUI
import SwiftData

@main
struct BLETestApp: App {
    @StateObject var model = SharedModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(model)
        }
    }
}
