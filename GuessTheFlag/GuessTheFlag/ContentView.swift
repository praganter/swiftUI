//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Batuhan Yetgin on 29.07.2023.
//

import SwiftUI

struct ContentView: View {
    @State private var showScore = false
    @State private var scoreTitle = ""
    @State private var countries = ["Estonia","France","Germany","Ireland","Italy", "Nigeria","Poland","Russia","Spain","UK","US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var score = 0
    @State private var totalQuestion = 1
    @State private var buttonText = ""
    @State private var alertMessage = ""
    
    var body: some View {
        
        ZStack{
            RadialGradient(stops: [
                .init(color: Color(red:0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red:0.76, green: 0.15, blue : 0.26), location: 0.3)], center: .top, startRadius: 200, endRadius: 700).ignoresSafeArea()
            
            VStack {
                Text("Guess The Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                Spacer()
                VStack(spacing:30){
                    VStack {
                        Text("Choose the rigt flag of ")
                            .font(.subheadline.weight(.heavy))
                            .foregroundStyle(.secondary)
                        Text(countries[correctAnswer]).font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            Image(countries[number])
                                .renderingMode(.original)
                                .clipShape(Capsule())
                                .shadow(radius: 5)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical , 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score \(score)")
                    .font(.title2.bold())
                    .foregroundColor(.white)
                
            }
            .padding()
            
        }.alert(scoreTitle, isPresented: $showScore){
            Button(buttonText , action: askQuestion)
        }message: {
            Text(alertMessage)
        }
    }
    
    func flagTapped(_ number: Int) {
        if(number == correctAnswer){
            scoreTitle = "Correct"
            score+=1
        }else {
            scoreTitle = "Wrong"
            score-=1
        }
        showScore = true
        totalQuestion += 1
        checkGameStatus(number)
    }
    
    func checkGameStatus(_ number : Int){
        if(totalQuestion < 9 ) {
            buttonText = "Continue"
            alertMessage = "The flag is \(countries[number])"
        }else {
            buttonText = "Restart"
            alertMessage = """
                            The flag is \(countries[number])
                            Your score is \(score)
                            """
        }
    }
    
    func askQuestion(){
        if(totalQuestion >= 9){
            totalQuestion = 1
            score = 0
        }
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
