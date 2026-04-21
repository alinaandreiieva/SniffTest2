//
//  BeginnerPredictionModels.swift
//  SniffTest
//
//  Created by Codex on 21/4/26.
//

import Foundation

struct BeginnerPredictionRequest: Encodable {
    let text: String
}

struct BeginnerPredictionResponse: Decodable {
    let count: Int
    let predictions: [BeginnerPrediction]
}

struct BeginnerPrediction: Decodable, Equatable {
    let statement: String
    let predictedCategory: String
    let confidence: Double
    let probabilities: [String: Double]

    enum CodingKeys: String, CodingKey {
        case statement
        case predictedCategory = "predicted_category"
        case confidence
        case probabilities
    }
}
