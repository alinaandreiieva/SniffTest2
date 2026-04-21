//
//  QuizViewModel.swift
//  SniffTest
//
//  Created by Alina Andreieva on 21/4/26.
//

import Combine
import Foundation

final class QuizViewModel: ObservableObject {
    @Published private(set) var currentLevel: QuizLevel = .beginner
    @Published private(set) var questions: [QuizQuestion] = []
    @Published private(set) var currentQuestionIndex = 0
    @Published private(set) var feedback: AnswerFeedback?
    @Published private(set) var selectedAnswer: QuizAnswer?
    @Published private(set) var hasAnsweredCurrentQuestion = false
    @Published private(set) var isRoundComplete = false
    @Published private(set) var numberOfCorrectAnswers = 0
    @Published private(set) var remainingTime = 0

    private let advancedTimeLimit = 12
    private var timer: Timer?

    init() {
        load(level: .beginner)
    }

    deinit {
        stopTimer()
    }

    var currentQuestion: QuizQuestion? {
        guard questions.indices.contains(currentQuestionIndex) else { return nil }
        return questions[currentQuestionIndex]
    }

    var progressTitle: String {
        guard !questions.isEmpty else { return "No questions yet" }
        return "Question \(currentQuestionIndex + 1) of \(questions.count)"
    }

    var scoreTitle: String {
        "\(numberOfCorrectAnswers) correct"
    }

    var showsTimer: Bool {
        currentLevel == .advanced && !isRoundComplete
    }

    var completionMessage: String {
        switch currentLevel {
        case .beginner:
            return "You handled the core red flags. Next up: naming the exact disinformation technique."
        case .intermediate:
            return "You are ready for mixed questions under pressure."
        case .advanced:
            return "Nice work. You completed the timed mixed challenge."
        }
    }

    var primaryCompletionActionTitle: String {
        switch currentLevel {
        case .beginner:
            return "Go to Intermediate"
        case .intermediate:
            return "Go to Advanced"
        case .advanced:
            return "Play Advanced Again"
        }
    }

    func submit(_ answer: QuizAnswer) {
        guard let currentQuestion, !hasAnsweredCurrentQuestion, !isRoundComplete else { return }

        hasAnsweredCurrentQuestion = true
        selectedAnswer = answer
        stopTimer()

        let isCorrect = currentQuestion.isCorrect(answer)
        if isCorrect {
            numberOfCorrectAnswers += 1
        }

        feedback = AnswerFeedback(
            title: isCorrect ? "Nice catch" : "Almost there",
            message: currentQuestion.explanation,
            kind: isCorrect ? .success : .warning
        )
    }

    func advance() {
        guard hasAnsweredCurrentQuestion else { return }

        feedback = nil
        selectedAnswer = nil

        let nextIndex = currentQuestionIndex + 1
        if questions.indices.contains(nextIndex) {
            currentQuestionIndex = nextIndex
            hasAnsweredCurrentQuestion = false
            startTimerIfNeeded()
        } else {
            isRoundComplete = true
            stopTimer()
        }
    }

    func advanceToNextLevel() {
        switch currentLevel {
        case .beginner:
            load(level: .intermediate)
        case .intermediate:
            load(level: .advanced)
        case .advanced:
            load(level: .advanced)
        }
    }

    func restartCurrentLevel() {
        load(level: currentLevel)
    }

    func resetToBeginning() {
        load(level: .beginner)
    }

    private func load(level: QuizLevel) {
        currentLevel = level
        questions = questionsForLevel(level)
        currentQuestionIndex = 0
        feedback = nil
        selectedAnswer = nil
        hasAnsweredCurrentQuestion = false
        isRoundComplete = false
        numberOfCorrectAnswers = 0
        remainingTime = showsTimer ? advancedTimeLimit : 0
        startTimerIfNeeded()
    }

    private func questionsForLevel(_ level: QuizLevel) -> [QuizQuestion] {
        switch level {
        case .beginner:
            return QuizContent.beginnerQuestions
        case .intermediate:
            return QuizContent.intermediateQuestions
        case .advanced:
            return Array((QuizContent.beginnerQuestions + QuizContent.intermediateQuestions).shuffled().prefix(6))
        }
    }

    private func startTimerIfNeeded() {
        stopTimer()

        guard currentLevel == .advanced, !hasAnsweredCurrentQuestion, !isRoundComplete else {
            remainingTime = 0
            return
        }

        remainingTime = advancedTimeLimit
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.tickTimer()
        }
    }

    private func tickTimer() {
        guard currentLevel == .advanced, !hasAnsweredCurrentQuestion else {
            stopTimer()
            return
        }

        if remainingTime > 0 {
            remainingTime -= 1
        }

        if remainingTime == 0 {
            handleTimeExpired()
        }
    }

    private func handleTimeExpired() {
        guard let currentQuestion, !hasAnsweredCurrentQuestion else { return }

        hasAnsweredCurrentQuestion = true
        stopTimer()
        feedback = AnswerFeedback(
            title: "Time's up",
            message: currentQuestion.explanation,
            kind: .timeout
        )
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}
