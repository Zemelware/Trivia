//
//  QuizData.swift
//  Trivia
//
//  Created by Ethan Zemelman on 2020-09-07.
//  Copyright © 2020 Ethan Zemelman. All rights reserved.
//

import Foundation
import GameplayKit

struct Results: Decodable {
    let response_code: Int
    let results: [Question]
}

struct Question: Decodable, Hashable {
    let category: String
    let type: String
    let difficulty: String
    let question: String
    let correct_answer: String
    let incorrect_answers: [String]
    var possibleAnswers: [String] {
        if type == "multiple" {
            // Multiple choice
            var answers = incorrect_answers
            answers.append(correct_answer)
            
            // This ensures that the shuffle of the array is the same every time so the buttons are in the same order.
            let lcg = GKLinearCongruentialRandomSource(seed: UInt64(abs(hashValue)))
            let shuffledArray = lcg.arrayByShufflingObjects(in: answers) as! [String]
            return shuffledArray
        } else {
            // True or false
            // True should always be the first option, and false the second
            return ["True", "False"]
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(category)
        hasher.combine(type)
        hasher.combine(difficulty)
        hasher.combine(question)
        hasher.combine(correct_answer)
        hasher.combine(incorrect_answers)
    }
}
