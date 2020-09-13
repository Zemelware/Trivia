//
//  AnswersView.swift
//  Trivia
//
//  Created by Ethan Zemelman on 2020-09-12.
//  Copyright © 2020 Ethan Zemelman. All rights reserved.
//

import SwiftUI

struct AnswersView: View {
    
    let questions: [Question]
    
    var body: some View {
        List(questions) { question in
            VStack {
                Text(question.question).padding(.vertical)
                
                ForEach(question.possibleAnswers, id: \.self) { answer in
                    AnswerButtonLabel(answerText: answer, correctAnswer: question.correct_answer, answerTapped: true).padding(.bottom)
                }
            }
        }.onAppear {
            UITableView.appearance().backgroundColor = .systemGreen
            UITableViewCell.appearance().backgroundColor = .systemGreen
        }
        .onDisappear {
            UITableView.appearance().backgroundColor = .systemGray6
            UITableViewCell.appearance().backgroundColor = .white
        }
    }
}

struct AnswersView_Previews: PreviewProvider {
    static var previews: some View {
        AnswersView(questions: [Question(category: "Category", type: "boolean", difficulty: "Difficulty", question: "Question", correct_answer: "True", incorrect_answers: ["False"])])
    }
}
