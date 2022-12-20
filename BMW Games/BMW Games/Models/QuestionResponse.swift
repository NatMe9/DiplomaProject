//
//  QuestionResponse.swift
//  BMW Games
//
//  Created by Natalia Givojno on 3.12.22.
//

import Foundation

//В QuestionsResponse лежит массив [Question], а в нем массив [Answer]

// MARK: - QuestionsResponse
struct QuestionsResponse: Codable {
    let items: [Question]
}

// MARK: - Item
class Question: Codable {
    let id: Int
    let text, image: String?
    let category: String
    let answers: [Answer]
}

// MARK: - Answer
class Answer: Codable {
    let id: Int
    let text: String
    let isCorrect: Bool
    var isSelected: Bool
}
