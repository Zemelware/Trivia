//
//  ContentView.swift
//  Trivia
//
//  Created by Ethan Zemelman on 2020-09-07.
//  Copyright © 2020 Ethan Zemelman. All rights reserved.
//

import SwiftUI

struct CreateQuizView: View {
    
    @ObservedObject private var networkManager = NetworkManager()
    
    @State private var numberOfQuestions = 10
    @State private var selectedCategory = Category(id: 0, name: "Any")
    @State private var selectedDifficulty = "Any"
    @State private var selectedType = "Any"
    
    private let difficulties = ["Any", "Easy", "Medium", "Hard"]
    private let questionTypes = ["Any", "Multiple Choice", "True or False"]
    
    var body: some View {
        NavigationView {
            VStack {
                
                Form {
                    
                    Section {
                        Stepper(value: $numberOfQuestions, in: 1...50) {
                            Text("Number of Questions: \(numberOfQuestions)")
                        }
                    }
                    
                    Section {
                        Picker("Category", selection: $selectedCategory) {
                            ForEach(networkManager.categories, id: \.self) { category in
                                Text(category.name)
                            }
                        }
                    }
                    
                    Section(header: Text("Difficulty")) {
                        Picker("Difficulty", selection: $selectedDifficulty) {
                            ForEach(difficulties, id: \.self) { difficulty in
                                Text(difficulty)
                            }
                        }.pickerStyle(SegmentedPickerStyle())
                    }
                    
                    Section(header: Text("Question Type")) {
                        Picker("Question Type", selection: $selectedType) {
                            ForEach(questionTypes, id: \.self) { type in
                                Text(type)
                            }
                            }.pickerStyle(SegmentedPickerStyle())
                    }

                }
                
                NavigationLink(destination: QuizView(numberOfQuestions: self.numberOfQuestions, selectedCategoryID: self.selectedCategory.id, selectedDifficulty: self.selectedDifficulty, selectedType: self.selectedType)) {
                    Text("Generate Quiz")
                        .padding(.vertical)
                        .padding(.horizontal, 80)
                        .font(.headline)
                        .foregroundColor(.white)
                        .background(Color.green)
                        .cornerRadius(15)
                }.offset(x: 0, y: -10)
                
            }
            .navigationBarTitle("Trivia")
            .background(Color(.systemGray6).edgesIgnoringSafeArea(.all))
        }
        .onAppear {
            UITableView.appearance().backgroundColor = .systemGray6 // Changing the form background color
            self.networkManager.fetchCategories()
        }
    }
}

struct CreateQuizView_Previews: PreviewProvider {
    static var previews: some View {
        CreateQuizView()
    }
}
