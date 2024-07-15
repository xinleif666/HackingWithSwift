//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Paul Hudson on 11/10/2023.
//  Modified by Xinlei Feng on 07/15/2024.
//

import SwiftUI

struct FlagImage: View {
    var imageName: String
    
    var body: some View {
        Image(imageName)
            .clipShape(Capsule())
            .shadow(radius: 5)
    }
}

struct FlagButton: View {
    var imageName: String
    var rotation: Double
    var isChosen: Bool

    var body: some View {
        FlagImage(imageName: imageName)
            .rotation3DEffect(
                .degrees(rotation),
                axis: (x: 0.0, y: 1.0, z: 0.0)
            )
            .opacity(isChosen ? 1 : 0.25)
            .scaleEffect(isChosen ? CGSize(width: 1, height: 1) : CGSize(width: 0.5, height: 0.5))
    }
}

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)

    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var userScore = 0
    @State private var chosenFlag: Int? = nil
    @State private var questionLeft = 8
    @State private var showingRestart = false
    @State private var rotations = [0.0, 0.0, 0.0]
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()

            VStack {
                Spacer()

                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)

                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            withAnimation(.spring()) {
                                rotations[number] += 360
                                flagTapped(number)
                            }
                        } label: {
                            FlagButton(
                                imageName: countries[number],
                                rotation: rotations[number],
                                isChosen: chosenFlag == nil || chosenFlag == number
                            )
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                Spacer()
                Spacer()

                Text("Score: \(userScore)")
                    .foregroundStyle(.white)
                    .font(.title.bold())

                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            if scoreTitle == "Correct" {
                Text("Your score is \(userScore)")
            } else {
                Text("Wrong! That's the flag of \(countries[chosenFlag ?? 0])")
            }
        }
        
        .alert("You completed 8 questions", isPresented: $showingRestart) {
            Button("Restart", action: reset)
        } message: {
            Text("Your final score is \(userScore). Restart the game?")
        }
    }

    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            userScore += 1
        } else {
            scoreTitle = "Wrong"
            userScore -= 1
        }

        showingScore = true
        chosenFlag = number
        questionLeft -= 1
        if questionLeft == 0 {
            showingRestart = true
        }
    }

    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        chosenFlag = nil
    }
    
    func reset() {
        questionLeft = 8
        userScore = 0
        askQuestion()
    }
}

#Preview {
    ContentView()
}
