//
//  ContentView.swift
//  WordScramble
//
//  Created by Rodrigo Carballo on 10/13/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    @State private var scoreLetters = 0
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
        

    var body: some View {
        NavigationStack {
            List {
                Section {
                    TextField("Enter your word", text: $newWord)
                        .textInputAutocapitalization(.never)
                }
                Section {
                    ForEach(usedWords, id: \.self) { word in
                        HStack {
                            Image(systemName: "\(word.count).circle")
                            Text(word)
                        }
                        
                    }
                }
                Section {
                    
                    Text("Score is: \(usedWords.count + scoreLetters)")
                }
                
            }
            .navigationTitle(rootWord)
            .toolbar {
                Button("Launch") {
                    startGame()
                    usedWords = []
                    scoreLetters = 0
                    
                }
            }
            .onSubmit(addNewWord)
            .onAppear(perform: startGame)
            .alert(errorTitle, isPresented: $showingError) {
                Button("OK") { }
            } message: {
                Text(errorMessage)
            }
        }
        
        
    }
    
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard answer.count > 0 else { return }
        
        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Be more original")
            return
        }

        guard isPossible(word: answer) else {
            wordError(title: "Word not possible", message: "You can't spell that word from '\(rootWord)'!")
            return
        }

        guard isReal(word: answer) else {
            wordError(title: "Word not recognized", message: "You can't just make them up, you know!")
            return
        }
        
        guard isSmallerThanThreeLetters(word:answer) else {
            wordError(title: "Word is smaller than 3 letters", message: "Time to expand your vocabulary")
            return
        }
        
        guard startsWithStartword(word: answer) else {
            wordError(title: "Word chosen uses start letters from root", message: "Use something that does not start with first three words")
            return
        }
        
        withAnimation {
            usedWords.insert(answer, at: 0)
            scoreLetters = scoreLetters + answer.count
        }
        newWord = ""
    }
    
    func startGame() {
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                let allWords = startWords.components(separatedBy: "\n")
                
                rootWord = allWords.randomElement() ?? "silkworm"
                
                return

            }
        }
        fatalError("Couldn't load start.txt from bundle")
    }
    
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord

        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }

        return true
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")

        return misspelledRange.location == NSNotFound
    }
    
    func isSmallerThanThreeLetters(word : String) -> Bool {
        if (word.count <= 3) {
            return false
        }
        return true
    }
    
    func startsWithStartword(word: String) -> Bool {
        
        let tempWord = rootWord
        let firstThreeLetters = String(tempWord.prefix(word.count))
        
        if(firstThreeLetters == word) {
            return false
        }
        
        return true

    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
}

#Preview {
    ContentView()
}
