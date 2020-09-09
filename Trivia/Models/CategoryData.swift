//
//  CategoryData.swift
//  Trivia
//
//  Created by Ethan Zemelman on 2020-09-07.
//  Copyright © 2020 Ethan Zemelman. All rights reserved.
//

import Foundation

struct CategoryResults: Decodable {
    let trivia_categories: [Category]
}

struct Category: Decodable, Identifiable, Hashable {
    let id: Int
    let name: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
