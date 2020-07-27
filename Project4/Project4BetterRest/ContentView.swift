//
//  ContentView.swift
//  Project4BetterRest
//
//  Created by Niraj on 27/07/2020.
//  Copyright © 2020 Technomystic. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount: Double = 8
    @State private var coffeeAmount = 1

    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false


    var body: some View {
        NavigationView {
            VStack {
                Text("When do you want to wake up?")
                    .font(.headline)
                    .lineLimit(nil)

                DatePicker("", selection: $wakeUp, displayedComponents: .hourAndMinute)

                Text("Desired amount of sleep?")
                    .font(.headline)
                    .lineLimit(nil)
                Stepper("\(sleepAmount, specifier: "%g") hours", value: $sleepAmount, in: 4...12, step: 0.25)
                    .padding(.bottom)

                Text("Coffee cups intake?")
                    .font(.headline)
                    .lineLimit(nil)
                Stepper(value: $coffeeAmount, in: 1...20) {
                    if coffeeAmount == 1 {
                        Text("1 Cup")
                    } else {
                        Text("\(coffeeAmount) cups")
                    }
                }

                Spacer()
            }
        .navigationBarTitle(Text("Better Rest"))
            .navigationBarItems(trailing:
                Button(action: calculateSleep, label: {
                    Text("Calculate")
                })
            )
            .padding()
                .alert(isPresented: $showingAlert) { () -> Alert in
                    Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }

    }

    static var defaultWakeTime: Date {
        var component = DateComponents()
        component.hour = 8
        component.minute = 0
        return Calendar.current.date(from: component) ?? Date()
    }

    func calculateSleep() {
        let model = SleepCalculator()

        do {
            let component = Calendar.current.dateComponents([.hour,.minute], from: wakeUp)
            let hour = (component.hour ?? 0) * 60 * 60
            let minute = (component.minute ?? 0) * 60

            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))

            let formatter = DateFormatter()
            formatter.timeStyle = .short

            let sleepTime = wakeUp - prediction.actualSleep
            alertMessage = formatter.string(from: sleepTime)
            alertTitle = "Your bedtime is..."

        } catch {
            alertTitle = "Error"
            alertMessage = "Something wrong with your bedtime"
        }

        showingAlert = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
