//
//  ContentView.swift
//  WordScramble
//
//  Created by Batuhan Yetgin on 31.07.2023.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    @State private var score = 0
    
    var body: some View {
        NavigationView{
           
                List {
                    Section {
                        TextField("Enter your word", text: $newWord)
                            .onSubmit(addNewWord)
                            .autocapitalization(.none)
                            .autocorrectionDisabled(true)
                    }
                    
                    Section {
                        ForEach(usedWords, id: \.self){word in
                            HStack{
                                Image(systemName: "\(word.count).circle")
                                Text(word)
                            }
                        }
                    }
                    
                   Section {
                        Text("Score : \(score)")
                    }
                }
                
            
            .navigationTitle(rootWord)
            .onAppear(perform:startGame)
            .alert(errorTitle, isPresented: $showingError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button("Start Game", action: startGame)
                }
            }
        }
    }
    
    func addNewWord(){
        let answer = newWord.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
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
        
        guard isAcceptable(word: answer) else {
            wordError(title: "Word is illegal :)", message: "Word can not be shorten than three characters and can not be the same as rootword.")
            return
        }
        withAnimation
        {
            usedWords.insert(answer, at: 0)
            calculateScore()
        }
        newWord = ""
    }
    
    func startGame(){
        if let startWordsUrl = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsUrl) {
                let allWords = startWords.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "default"
                return
            }
        }
        fatalError("Could not find start.txt file in bundle")
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
    
    func isAcceptable(word: String) -> Bool {
        if(word.count < 3) {
            return false
        }
        if(word == rootWord) {
            return false
        }
        return true
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
    
    private func calculateScore(){
        var temp = 0
        for  word in usedWords {
            temp += word.count
        }
        score = temp
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
