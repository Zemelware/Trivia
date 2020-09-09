//
//  QuizView.swift
//  Trivia
//
//  Created by Ethan Zemelman on 2020-09-07.
//  Copyright © 2020 Ethan Zemelman. All rights reserved.
//

import SwiftUI

struct QuizView: View {
    
    var numberOfQuestions: Int
    var selectedCategoryID: Int
    var selectedDifficulty: String
    var selectedType: String
    
    @ObservedObject private var networkManager = NetworkManager()
    
    @State private var currentQuestionIndex = 0
    @State private var score = 0
    @State private var answerTapped = false
    
    private var currentDifficulty: String {
        if networkManager.questions.count != 0 {
            return networkManager.questions[currentQuestionIndex].difficulty
        } else {
            return "Difficulty"
        }
    }
    private var difficultyColor: Color {
        if currentDifficulty == "easy" {
            return .blue
        } else if currentDifficulty == "medium" {
            return .yellow
        } else {
            return .red
        }
    }

    private var currentQuestion: Question {
        networkManager.questions[currentQuestionIndex]
    }
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        ZStack {
            Color.green.edgesIgnoringSafeArea(.all)
            
            VStack {
                
                HStack(alignment: .center) {
                    Text(networkManager.questions.count == 0 ? "Category" : currentQuestion.category)
                        .font(.system(size: 20))
                        .padding(.trailing, 15)
                    
                    Spacer()
                    
                    Text(currentDifficulty.capitalized)
                        .font(.system(size: 20))
                        .padding(.vertical, 5)
                        .padding(.horizontal, 15)
                        .background(difficultyColor)
                        .clipShape(Capsule())
                        .padding(.leading, 15)
                }.padding(.horizontal, 20)
                
                Spacer()
                
                Text(networkManager.questions.count == 0 ? "Question" : currentQuestion.question)
                    .padding(.top, 10)
                    .font(.system(size: 30))
                    .frame(width: screenWidth - 40)
                
                Spacer()
                Spacer()
                
                VStack(spacing: 10) {
                    
                    if networkManager.questions.count != 0 {
                        
                        ForEach(currentQuestion.possibleAnswers, id: \.self) { answer in
                            Button(action: {
                                if answer == self.currentQuestion.correct_answer {
                                    self.score += 1
                                }
                                self.answerTapped = true
                            }) {
                                AnswerButtonLabel(answerText: answer, correctAnswer: self.currentQuestion.correct_answer, answerTapped: self.answerTapped)
                            }.disabled(self.answerTapped)
                        }
                        
                    } else {
                        Text("True")
                            .frame(width: screenWidth - 40)
                            .padding(.vertical)
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(15)
                        
                        Text("False")
                            .frame(width: screenWidth - 40)
                            .padding(.vertical)
                            .foregroundColor(.white)
                            .background(Color.red)
                            .cornerRadius(15)
                    }
                    
                }.padding(.bottom)
                
                if networkManager.questions.count != 0 {
                    HStack {
                        Button(action: {
                            self.currentQuestionIndex -= 1
                            self.answerTapped = true
                        }) {
                            Text("Previous")
                        }.disabled(self.currentQuestionIndex == 0 ? true : false)
                        
                        Spacer()
                        
                        Text("Question \(currentQuestionIndex + 1)")
                        
                        Spacer()
                        
                        Button(action: {
                            self.currentQuestionIndex += 1
                            self.answerTapped = false
                        }) {
                            Text("Next")
                        }.disabled(!answerTapped)
                    }.padding(.horizontal, 20)
                }
                
            }
        }
        .navigationBarTitle("Score: \(score)")
        .onAppear {
            self.networkManager.fetchQuestions(questions: self.numberOfQuestions, categoryID: self.selectedCategoryID, difficulty: self.selectedDifficulty, type: self.selectedType)
        }
    }
    
}

struct QuizView_Previews: PreviewProvider {
    static var previews: some View {
        QuizView(numberOfQuestions: 10, selectedCategoryID: 0, selectedDifficulty: "Any Difficulty", selectedType: "Any Type")
    }
}
