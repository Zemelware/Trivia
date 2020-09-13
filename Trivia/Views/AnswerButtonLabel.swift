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
    
    private var checkmarkImage: Image? {
        if answerTapped && answerText == correctAnswer {
            return Image(systemName: "checkmark.circle.fill")
        }
        return nil
    }
    
    private let screenWidth = UIScreen.main.bounds.width
    
    var body: some View {
        Text(answerText)
            .frame(width: self.screenWidth - 40)
            .padding(.vertical)
            .foregroundColor(answerTapped && answerText == correctAnswer ? .green : .white)
            .font(answerTapped && answerText == correctAnswer ? Font.body.weight(.black) : .body)
            .background(answerText == "False" ? Color.red : Color.blue)
            .cornerRadius(15)
            .overlay(checkmarkImage.foregroundColor(.green).font(.system(size: 30)).padding(.trailing, 10), alignment: .trailing)
    }
}

struct AnswerButtonLabel_Previews: PreviewProvider {
    static var previews: some View {
        AnswerButtonLabel(answerText: "True", correctAnswer: "True", answerTapped: true).previewLayout(.sizeThatFits)
    }
}
