//
//  AnswerButtonLabel.swift
//  Trivia
//
//  Created by Ethan Zemelman on 2020-09-08.
//  Copyright © 2020 Ethan Zemelman. All rights reserved.
//

import SwiftUI

struct AnswerButtonLabel: View {
    
    var answerText: String
    var correctAnswer: String
    var answerTapped: Bool
    
    let screenWidth = UIScreen.main.bounds.width
    
    var body: some View {
        Text(answerText)
            .frame(width: self.screenWidth - 40)
            .padding(.vertical)
            .foregroundColor(self.answerTapped && answerText == self.correctAnswer ? .green : .white)
            .font(self.answerTapped && answerText == self.correctAnswer ? Font.body.bold() : .body)
            .background(answerText == "False" ? Color.red : Color.blue)
            .cornerRadius(15)
    }
}

struct AnswerButtonLabel_Previews: PreviewProvider {
    static var previews: some View {
        AnswerButtonLabel(answerText: "True", correctAnswer: "True", answerTapped: false)
    }
}
