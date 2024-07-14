//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Xinlei Feng on 7/14/24.
//

import SwiftUI

struct ContentView: View {
    @State private var userScore = 0
    private let moves = ["Rock", "Paper", "Scissors"]
    private let winMoves = ["Paper", "Scissors", "Rock"]
    @State private var appChoice = Int.random(in: 0..<3)
    @State private var questionLeft = 10
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showAlert = false

    var body: some View {
        VStack(spacing: 30) {
            Text("Make your choice!")
                .font(.system(size: 40))

            Text("Your score: \(userScore)")
                .font(.title)

            HStack {
                ForEach(0..<3) { index in
                    Button(action: {
                        self.buttonTapped(index)
                    }) {
                        Text(self.moves[index])
                            .font(.system(size: 40))
                    }
                }
            }
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text(questionLeft > 0 ? "Next Round" : "Restart"), action: {
                if questionLeft == 0 {
                    self.restartGame()
                } else {
                    self.nextTurn()
                }
            }))
        }
    }

    func buttonTapped(_ number: Int) {
        if questionLeft == 0 {
            return
        }

        let correctAnswer = winMoves[appChoice]

        if moves[number] == moves[appChoice] {
            alertTitle = "Tie"
            alertMessage = "It's a tie! No points awarded."
        } else if moves[number] == correctAnswer {
            userScore += 1
            alertTitle = "Correct! The App chose \(moves[appChoice])"
            alertMessage = "You won this round."
        } else {
            userScore -= 1
            alertTitle = "Incorrect! The App chose \(moves[appChoice])"
            alertMessage = "You lost this round."
        }

        questionLeft -= 1
        
        if questionLeft == 0 {
            alertTitle = "Game over"
            alertMessage = "Your final score is \(userScore)."
        }

        showAlert = true
    }

    func nextTurn() {
        appChoice = Int.random(in: 0..<3)
    }

    func restartGame() {
        appChoice = Int.random(in: 0..<3)
        questionLeft = 4
        userScore = 0
        showAlert = false
    }
}

#Preview {
    ContentView()
}
