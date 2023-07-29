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
                
                Text("Score ???")
                    .font(.title2.bold())
                    .foregroundColor(.white)
                
            }
            .padding()
            
        }.alert(scoreTitle, isPresented: $showScore){
            Button("Continue" , action: askQuestion)
        }message: {
            Text("Your score is ???")
        }
    }
    
    func flagTapped(_ number: Int) {
        if(number == correctAnswer){
            scoreTitle = "Correct"
        }else {
            scoreTitle = "Wrong"
        }
        showScore = true
    }
    
    func askQuestion(){
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
