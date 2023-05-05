//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by GANDA on 05/05/23.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"]
        .shuffled()
    @State private var correctAnswer = Int.random(in: 0..<3)
    @State private var showingScore = false
    @State private var alertTitle = ""

    // challenge: user score
    @State private var score = 0

    // challenge: if flag wrong, tell them what flag it is
    @State private var alertMessage = ""

    // challenge: make the game only show 8 questions
    //  at which point they see a final alert judging their score and can restart the game.
    private var numberOfQuestions = 8
    @State private var questionIndex = 0
    @State private var showingFinalScore = false

    var body: some View {
        ZStack {

            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 400)
                .ignoresSafeArea()

            VStack {
                Spacer()

                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)

                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .font(.subheadline.weight(.heavy))
                            .foregroundStyle(.secondary)
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                            .foregroundStyle(.secondary)
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
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))

                Spacer()
                Spacer()

                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.largeTitle.bold())

                Spacer()
            }
            .padding()
        }
        .alert(alertTitle, isPresented: $showingScore) {
            Button("Continue", action: continueGame)
        } message: {
            Text(alertMessage)
        }
        .alert("Game Over", isPresented: $showingFinalScore) {
            Button("Restart", role: .cancel, action: resetGame)
        } message: {
            Text("Your final score is \(score)")
        }
    }

    private func flagTapped(_ number: Int) {
        if number == correctAnswer {
            score += 1
            alertTitle = "Correct"
            alertMessage = "Your score is \(score)"
        } else {
            alertTitle = "Wrong"
            alertMessage = "That's the flag of \(countries[correctAnswer])"
        }

        showingScore = true
        questionIndex += 1
    }

    private func continueGame() {
        if (questionIndex < numberOfQuestions) {
            askQuestion()
        } else {
            showingFinalScore = true
        }
    }

    private func askQuestion() {
        correctAnswer = Int.random(in: 0..<3)
        countries.shuffle()
    }

    private func resetGame() {
        score = 0
        questionIndex = 0
        alertTitle = ""
        alertMessage = ""

        askQuestion()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
