//
//  ContentView.swift
//  Edutainment
//
//  Created by Xinlei Feng on 7/15/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var tableNum = 2
    private let questionNumOptions = [5, 10, 20]
    @State private var questionNumChoice = 5
    @State private var questions: [(num1: Int, num2: Int)] = []
    @State private var currentQuestionIndex = 0
    @State private var answer = ""
    @State private var score = 0
    @State private var isGameActive = false
    @State private var finishAlert = false
    
    var body: some View {
        VStack {
            if isGameActive {
                gameSessionView
            } else {
                setupView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(LinearGradient(gradient: Gradient(colors: [.blue, .white]), startPoint: .top, endPoint: .bottom))
        .alert("Game Over!", isPresented: $finishAlert) {
            Button("Restart", action: resetGame)
            Button("OK", role: .cancel) { }
        } message: {
            Text("Your final score: \(score) out of \(questionNumChoice) questions")
        }
    }
    
    var gameSessionView: some View {
        VStack(alignment: .center, spacing: 20) {
            Text("Score: \(score)")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.green)
            
            let question = questions[currentQuestionIndex]
            Text("What is \(question.num1) * \(question.num2)?")
                .font(.title2)
                .fontWeight(.semibold)
            
            TextField("Your answer", text: $answer)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .padding()
                .frame(width: 150)
            
            Button(action: checkAnswer) {
                Text("Confirm")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.red)
                    .clipShape(Capsule())
            }
        }
        .transition(.scale)
    }
    
    func setupView() -> some View {
        VStack(spacing: 20) {
            Text("Multiplication Tables Choice")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(.white)
            
            Stepper("Up to \(tableNum) * \(tableNum) table", value: $tableNum, in: 2...12)
                .padding()
                .background(Color.purple.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            Text("Number of Questions")
                .font(.headline)
                .fontWeight(.semibold)
            
            Picker("Question number", selection: $questionNumChoice) {
                ForEach(questionNumOptions, id: \.self) {
                    Text("\($0)")
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            Button("Start Game") {
                startGame()
            }
            .foregroundColor(.white)
            .padding()
            .background(Color.blue)
            .clipShape(Capsule())
        }
        .padding()
        .background(Color.mint.opacity(0.3))
        .cornerRadius(20)
    }
    
    func startGame() {
        questions = (1...questionNumChoice).map { _ in
            (num1: Int.random(in: 1...tableNum), num2: Int.random(in: 1...tableNum))
        }
        currentQuestionIndex = 0
        score = 0
        isGameActive = true
    }
    
    func checkAnswer() {
        if Int(answer) == questions[currentQuestionIndex].num1 * questions[currentQuestionIndex].num2 {
            score += 1
        }
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
        } else {
            finishAlert = true
            isGameActive = false
        }
        answer = ""
    }
    
    func resetGame() {
        tableNum = 2
        questionNumChoice = 5
        startGame()
    }
}

#Preview {
    ContentView()
}
