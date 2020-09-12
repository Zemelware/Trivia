//
//  NetworkManager.swift
//  Trivia
//
//  Created by Ethan Zemelman on 2020-09-07.
//  Copyright © 2020 Ethan Zemelman. All rights reserved.
//

import Foundation

class NetworkManager: ObservableObject {
    
    @Published var questions = [Question]()
    @Published var categories = [Category]()
    @Published var responseCode = 0
    
    func fetchQuestions(questions: Int, categoryID: Int, difficulty: String, type: String, completed: (() -> ())? = nil) {
        let difficultyString = difficulty == "Any" ? "" : "&difficulty=\(difficulty.lowercased())"
        var typeString: String {
            if type == "Any" {
                return ""
            } else if type == "Multiple Choice" {
                return "&type=multiple"
            } else {
                return "&type=boolean"
            }
        }
        
        guard let url = URL(string: "https://opentdb.com/api.php?amount=\(questions)&category=\(categoryID)\(difficultyString)\(typeString)") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else { print(error!); return }
            
            if let data = data {
                do {
                    let results = try JSONDecoder().decode(Results.self, from: data)
                    
                    DispatchQueue.main.async {
                        self.questions = results.results
                        self.responseCode = results.response_code
                        
                        completed?()
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    func fetchCategories() {
        guard let url = URL(string: "https://opentdb.com/api_category.php") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else { print(error!); return }
            
            if let data = data {
                do {
                    let results = try JSONDecoder().decode(CategoryResults.self, from: data)
                    
                    DispatchQueue.main.async {
                        self.categories = [Category(id: 0, name: "Any")] + results.trivia_categories
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
}
