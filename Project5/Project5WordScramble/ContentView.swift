//
//  ContentView.swift
//  Project5WordScramble
//
//  Created by Niraj on 28/07/2020.
//  Copyright © 2020 Technomystic. All rights reserved.
//

import SwiftUI

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

struct ContentView: View {
    @State private var currentWord = ""
    @State private var usedWords = [String]()
    @State private var newWord = ""

    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false


    var body: some View {
        NavigationView {
            VStack {
                TextField("Placeholder", text: $newWord, onCommit: addNewWord)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                .padding()

                List(usedWords, id: \.self) { word in
                    Text(word)
                }
            }
        .navigationBarTitle(Text(currentWord))
            .onAppear() {
                self.startGame()
            }
            .alert(isPresented: $showingError) {
                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

    func startGame() {
        if let startWordUrl = Bundle.main.path(forResource: "start", ofType: "txt") {
            if let startWords = try? String(contentsOfFile: startWordUrl) {
                let allWords = startWords.components(separatedBy: "\n")
                currentWord = allWords.randomElement() ?? "silkworm"
                return
            }
        }

        fatalError("Could not load Start.txt file.")

    }

    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }

    func isPossible(word: String) -> Bool {
        var tempWord = currentWord.lowercased()

        for letter in word {
            if let pos = tempWord.range(of: String(letter)) {
                tempWord.remove(at: pos.lowerBound)
            } else {
                return false
            }
        }
        return true
    }

    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledWord = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledWord.location == NSNotFound

    }

    func addNewWord() {
        let lowerAnswer = newWord.lowercased()

        guard isOriginal(word: lowerAnswer) else {
            wordError(title: "Word already Used", message: "Be more Original")
            return
        }
        guard isPossible(word: lowerAnswer) else {
             wordError(title: "Word not Recognised", message: "You just can't make up words, you know!")
            return
        }
        guard isReal(word: lowerAnswer) else {
            wordError(title: "Word not possible", message: "That isnt a real word")
            return
        }
        usedWords.insert(lowerAnswer, at: 0)
        newWord = ""
    }

    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
