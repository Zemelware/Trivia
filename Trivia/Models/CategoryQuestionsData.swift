//
//  CategoryQuestionsData.swift
//  Trivia
//
//  Created by Ethan Zemelman on 2020-09-12.
//  Copyright © 2020 Ethan Zemelman. All rights reserved.
//

import Foundation

struct CategoryQuestionsData: Decodable {
    let category_question_count: CategoryQuestionCount
}

struct CategoryQuestionCount: Decodable {
    let total_question_count: Int
    let total_easy_question_count: Int
    let total_medium_question_count: Int
    let total_hard_question_count: Int
}
