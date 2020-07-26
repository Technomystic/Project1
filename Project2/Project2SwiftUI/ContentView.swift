//
//  ContentView.swift
//  Project2SwiftUI
//
//  Created by Niraj on 29/03/2020.
//  Copyright © 2020 Ashwatthaama. All rights reserved.
//

import SwiftUI

struct ContentView: View {
     @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Monaco", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
     @State private var correctAnswer = Int.random(in: 0...2)

    @State private var score = 0
    @State private var showalert: Bool = false
    @State private var alertText = ""

    var body: some View {
        NavigationView {
            VStack {
                      ForEach(0..<3) { number in
                          Image(self.countries[number])
                              .border(Color.black, width: 1)
                            .onTapGesture {
                                self.flagTapped(number)
                        }
                      }
                  }
            .navigationBarTitle(Text(countries[correctAnswer]))
            .alert(isPresented: $showalert) {
                Alert(title: Text("Score: \(score)"), message: Text(alertText), dismissButton: .default(Text("Okay")) {
                    self.askQuestions()
                    })
            }
        }
    }

    func flagTapped(_ tag: Int) {
        if tag == correctAnswer {
            score += 1
            alertText = "Correct"
        } else {
            score -= 1
            alertText = "Wrong"
        }
        showalert = true
    }

    func askQuestions() {
        countries = countries.shuffled()
        correctAnswer = Int.random(in: 0...2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
