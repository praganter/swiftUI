//
//  ContentView.swift
//  BetterRest
//
//  Created by Batuhan Yetgin on 30.07.2023.
//

import CoreML
import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
//    @State private var alertTitle = ""
//    @State private var alertMessage = ""
//    @State private var isAlertVisible = false
    
    static var defaultWakeTime : Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date.now
    }
    
    private var predictionBedtime : Date {
        let config = MLModelConfiguration()
        
        do {
            let model = try SleepCalculator(configuration: config)
            let components = Calendar.current.dateComponents([.hour,.minute], from: wakeUp)
            let hours = (components.hour ?? 0) * 60 * 60
            let minutes = (components.minute ?? 0) * 60
            
                let prediction = try model.prediction(wake: Double(hours + minutes), estimatedSleep: sleepAmount , coffee: Double(coffeeAmount + 1))
            return wakeUp - prediction.actualSleep
        } catch {
            return wakeUp
        }
    }
    
    
    var body: some View {
        NavigationView{
            Form{
                VStack(alignment: .trailing)
                {
                    Text("When do you want to wake up ?")
                        .font(.headline)
                    DatePicker("Please enter time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                
                Section
                {
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                } header: {
                    Text("Desired amount of sleep")
                        .font(.headline)
                }
                
                Section
                {
                    
                    Picker("Choose coffe intake", selection: $coffeeAmount){
                        ForEach(1...20, id: \.self){
                            Text("\($0) \($0 == 1 ? "cup" : "cups")")
                        }
                    }.labelsHidden()
                   // Stepper(coffeeAmount == 1 ? "1 cup" : "\(coffeeAmount) cups", value: $coffeeAmount, in: 1...20)
                } header: {
                    Text("Daily coffee intake")
                        .font(.headline)
                }
                
                Section {
                    Text("Recomended bedtime : \(predictionBedtime.formatted(date: .omitted, time: .shortened))")
                }
            }
            .navigationTitle("BetterRest")
        }
        
        
    }
//    func calculateBedTime() {
//        do {
//            let config = MLModelConfiguration()
//            let model = try SleepCalculator(configuration: config)
//            let components = Calendar.current.dateComponents([.hour,.minute], from: wakeUp)
//            let hours = (components.hour ?? 0) * 60 * 60
//            let minutes = (components.minute ?? 0) * 60
//            let prediction = try model.prediction(wake: Double(hours + minutes), estimatedSleep: sleepAmount , coffee: Double(coffeeAmount + 1))
//            let sleepTime = wakeUp - prediction.actualSleep
//
//            alertTitle = "Your ideal bedtime is"
//            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
//        } catch {
//            alertTitle = "Error"
//            alertMessage = "There was a problem calculating your bedtime"
//        }
//        isAlertVisible = true
//    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
