//
//  ContentView.swift
//  BLETest
//
//  Created by Emily Sun on 9/20/25.
//

import SwiftUI
import SwiftData
import Charts

struct ContentView: View {
    @EnvironmentObject var model: SharedModel
    
    var body: some View {
        NavigationStack {
            VStack {
                                
                Chart(model.myData.coords) { point in
                    LineMark(
                        x: .value("X", point.x),
                        y: .value("Y", point.y)
                    )
                }
                .chartXScale(domain: max(0, model.counter-10)...model.counter)
                .chartYScale(domain: 0...1.5)
                .frame(height: 200)
                .padding()
                
                HStack {
                    VStack {
                        Text("Graph Type:")
                        
                        Picker("Choose one", selection: $model.format) {
                            ForEach(model.formats, id: \.self) { option in
                                Text(option)
                            }
                        }
                        .pickerStyle(.menu)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.black, lineWidth: 2)
                            )
                    }
                    
                    VStack {
                        Text("Frequency:")
                        
                        Picker("Choose one", selection: $model.frequency) {
                            ForEach(model.frequencies, id: \.self) { option in
                                Text(String(format: "%.0f", option as Double))
                                    .tag(option as Double)
                            }
                        }
                        .pickerStyle(.menu)
                        .onChange(of: model.frequency) {
                            if model.isRunning {
                                model.startTimer()
                            }
                        }
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.black, lineWidth: 2)
                            )
                    }
                }
                
                HStack {
                    Button(model.isRunning ? "Stop" : "Start") {
                        if model.isRunning {
                            model.stopTimer()
                        } else {
                            model.startTimer()
                        }
                        model.isRunning.toggle()
                    }
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.black, lineWidth: 2)
                        )
                    
                    Button("Save") {
                        model.saveCoordsToFile()
                        model.myData.clearData()
                        model.stopTimer()
                        model.counter = 0
                    }
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.black, lineWidth: 2)
                        )
                }
            }
        }
        .navigationTitle("Home Screen")
    }
    
}

#Preview {
    ContentView()
        .environmentObject(SharedModel())
}
