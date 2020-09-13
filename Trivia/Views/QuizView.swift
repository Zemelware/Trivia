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
    @State private var correctQuestions = 0
    @State private var totalQuestions = 0
    @State private var availableQuestionsForDifficulty = 0
    @State private var answersTapped = [Bool]()
    @State private var showingAlert = false
    
    private var currentDifficulty: String {
        if networkManager.questions.count != 0 {
            return currentQuestion.difficulty
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
        if currentQuestionIndex != totalQuestions {
            return networkManager.questions[currentQuestionIndex]
        } else {
            return Question(category: "", type: "", difficulty: "", question: "", correct_answer: "", incorrect_answers: [String]())
        }
    }
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        ZStack {
            Color.green.edgesIgnoringSafeArea(.all)
            
            if answersTapped.count == 0 {
                Text("Loading Quiz...")
                .font(.title)
            } else if currentQuestionIndex == answersTapped.count {
                ResultsView(questions: networkManager.questions, correctQuestions: correctQuestions, totalQuestions: totalQuestions)
            } else {
                
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
                                        self.correctQuestions += 1
                                    }
                                    self.answersTapped[self.currentQuestionIndex] = true
                                }) {
                                    AnswerButtonLabel(answerText: answer, correctAnswer: self.currentQuestion.correct_answer, answerTapped: self.answersTapped[self.currentQuestionIndex])
                                }.disabled(self.answersTapped[self.currentQuestionIndex])
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
                            }) {
                                Text("Previous")
                            }.disabled(self.currentQuestionIndex == 0 ? true : false)
                            
                            Spacer()
                            
                            Text("Question \(currentQuestionIndex + 1)")
                            
                            Spacer()
                            
                            Button(action: {
                                self.currentQuestionIndex += 1
                            }) {
                                Text(currentQuestionIndex + 1 != totalQuestions ? "Next" : "Submit")
                            }.disabled(!self.answersTapped[currentQuestionIndex])
                        }.padding(.horizontal, 20)
                    }
                    
                }
            }
            
        }
        .navigationBarTitle("Score: \(correctQuestions)")
        .onAppear {
            self.totalQuestions = self.numberOfQuestions
            
            self.fetchQuestions {
                self.answersTapped = Array(repeating: false, count: self.networkManager.questions.count)
                
                // If response code is 1, it means there were no results, but there could be results if fewer questions were passed in.
                if self.networkManager.responseCode == 1 {
                    
                    self.networkManager.fetchCategoryQuestionsData(categoryID: self.selectedCategoryID) {
                        
                        if self.selectedDifficulty == "Easy" {
                            self.availableQuestionsForDifficulty = self.networkManager.categoryQuestionCount.total_easy_question_count
                        } else if self.selectedDifficulty == "Medium" {
                            self.availableQuestionsForDifficulty = self.networkManager.categoryQuestionCount.total_medium_question_count
                        } else if self.selectedDifficulty == "Hard" {
                            self.availableQuestionsForDifficulty = self.networkManager.categoryQuestionCount.total_hard_question_count
                        } else { // Any difficulty
                            self.availableQuestionsForDifficulty = self.networkManager.categoryQuestionCount.total_question_count
                        }
                        
                        self.totalQuestions = self.availableQuestionsForDifficulty
                        
                        self.fetchQuestions(questions: self.availableQuestionsForDifficulty) {
                            self.answersTapped = Array(repeating: false, count: self.networkManager.questions.count)
                        }
                        
                        self.showingAlert = true
                    }
                }
            }
        }
        .alert(isPresented: $showingAlert) {
            var message = ""
            if availableQuestionsForDifficulty == 0 {
                message = "Sorry, there aren't any questions for the chosen quiz configuration."
            } else {
                message = "Sorry, there are only \(availableQuestionsForDifficulty) \(availableQuestionsForDifficulty == 1 ? "question" : "questions") for the chosen quiz configuration."
            }
            
            return Alert(title: Text("There aren't \(numberOfQuestions) \(availableQuestionsForDifficulty == 1 ? "Question" : "Questions")!"), message: Text(message), dismissButton: .default(Text("Okay")))
        }
    }
    
    func fetchQuestions(questions: Int? = nil, completed: (() -> ())? = nil) {
        networkManager.fetchQuestions(questions: questions == nil ? numberOfQuestions : questions!, categoryID: selectedCategoryID, difficulty: selectedDifficulty, type: selectedType) {
            completed?()
        }
    }
    
}

struct QuizView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            QuizView(numberOfQuestions: 10, selectedCategoryID: 0, selectedDifficulty: "Any Difficulty", selectedType: "Any Type")
        }
    }
}
