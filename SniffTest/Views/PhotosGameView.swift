//
//  PhotosGameView.swift
//  SniffTest
//
//  Created by Alina Andreieva on 21/4/26.
//

import SwiftUI

struct PhotosGameView: View {
    @ObservedObject var viewModel: QuizViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.background
                    .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        levelHeader

                        if viewModel.isRoundComplete {
                            completionCard
                        } else if let question = viewModel.currentQuestion {
                            questionCard(question)
                        }
                    }
                    .padding(.horizontal)
                }
                .blur(radius: viewModel.feedback == nil ? 0 : 2)
                .overlay {
                    if viewModel.feedback != nil {
                        Color.black.opacity(0.18)
                            .ignoresSafeArea()
                    }
                }
                .disabled(viewModel.feedback != nil)

                if let feedback = viewModel.feedback {
                    FeedbackOverlayView(feedback: feedback, action: viewModel.advance)
                        .padding(.horizontal, 24)
                        .transition(.scale(scale: 0.96).combined(with: .opacity))
                }
            }
            .animation(.spring(duration: 0.3), value: viewModel.feedback?.id)
            .animation(.easeInOut, value: viewModel.isRoundComplete)
            .toolbar(viewModel.isRoundComplete ? .visible : .hidden, for: .tabBar)
            .toolbar {
                if !viewModel.isRoundComplete {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("End Game", action: viewModel.endRoundEarly)
                    }
                }
            }
        }
    }

    private var levelHeader: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(viewModel.currentLevel.title)
                        .font(.title.bold())
                    Text(viewModel.currentLevel.subtitle)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                if viewModel.showsTimer {
                    TimerBadgeView(remainingTime: viewModel.remainingTime)
                }
            }

            HStack {
                Label(viewModel.progressTitle, systemImage: "list.number")
                Spacer()
                Label(viewModel.scoreTitle, systemImage: "checkmark.seal")
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }
    }

    private func questionCard(_ question: QuizQuestion) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            DemoQuestionMediaView(question: question)

            VStack(alignment: .leading, spacing: 10) {
                Text(question.title)
                    .font(.title3.weight(.semibold))

                Text(question.detail)
                    .foregroundStyle(.secondary)
            }

            VStack(spacing: 12) {
                ForEach(question.answers) { answer in
                    AnswerButton(
                        title: answer.label,
                        isDisabled: viewModel.hasAnsweredCurrentQuestion,
                        isSelected: viewModel.selectedAnswer == answer
                    ) {
                        viewModel.submit(answer)
                    }
                }
            }

        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(AppTheme.quizContainer)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .stroke(Color.black.opacity(0.08), lineWidth: 1)
        )
    }

    private var completionCard: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text(viewModel.completionTitle)
                .font(.title2.bold())

            Text(viewModel.completionMessage)
                .foregroundStyle(.secondary)

            HStack {
                Label(viewModel.scoreTitle, systemImage: "star.fill")
                Spacer()
                Label("\(viewModel.questions.count) total", systemImage: "number")
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)

            Button(action: viewModel.advanceToNextLevel) {
                Text(viewModel.primaryCompletionActionTitle)
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
            }
            .appPrimaryButtonStyle()

            Button(action: viewModel.restartCurrentLevel) {
                Text("Restart Level")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
            }
            .buttonStyle(.bordered)

            if viewModel.currentLevel != .beginner {
                Button(action: viewModel.resetToBeginning) {
                    Text("Back to Beginner")
                        .font(.subheadline.weight(.semibold))
                }
                .buttonStyle(.plain)
                .foregroundStyle(.secondary)
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(AppTheme.quizContainer)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .stroke(Color.black.opacity(0.08), lineWidth: 1)
        )
    }
}

private struct AnswerButton: View {
    let title: String
    let isDisabled: Bool
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.headline)
                Spacer()
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(isSelected ? .indigo : .secondary)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(isSelected ? Color.indigo.opacity(0.14) : .white.opacity(0.88))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(isSelected ? Color.indigo : Color.gray.opacity(0.18), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .disabled(isDisabled)
        .opacity(isDisabled && !isSelected ? 0.65 : 1)
    }
}

private struct FeedbackOverlayView: View {
    let feedback: AnswerFeedback
    let action: () -> Void

    private var tint: Color {
        switch feedback.kind {
        case .success:
            return .green
        case .warning:
            return .orange
        case .timeout:
            return .pink
        }
    }

    private var iconName: String {
        switch feedback.kind {
        case .success:
            return "checkmark.circle.fill"
        case .warning:
            return "lightbulb.fill"
        case .timeout:
            return "timer"
        }
    }

    var body: some View {
        VStack(spacing: 18) {
            Image(systemName: iconName)
                .font(.system(size: 28, weight: .semibold))
                .foregroundStyle(tint)

            VStack(alignment: .center, spacing: 8) {
                Text(feedback.title)
                    .font(.title3.weight(.semibold))

                Text(feedback.message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            Button(action: action) {
                Text("OK")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
            }
            .appPrimaryButtonStyle()
        }
        .padding(24)
        .frame(maxWidth: 360)
        .background(.white, in: RoundedRectangle(cornerRadius: 28, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(tint.opacity(0.35), lineWidth: 1.5)
        )
        .shadow(color: .black.opacity(0.12), radius: 24, y: 12)
    }
}

private struct DemoQuestionMediaView: View {
    let question: QuizQuestion

    private var palette: [Color] {
        switch question.tone {
        case .sky:
            return [.blue.opacity(0.24), .cyan.opacity(0.16)]
        case .amber:
            return [.orange.opacity(0.24), .yellow.opacity(0.16)]
        case .mint:
            return [.green.opacity(0.22), .mint.opacity(0.16)]
        case .coral:
            return [.red.opacity(0.20), .orange.opacity(0.16)]
        case .violet:
            return [.indigo.opacity(0.22), .purple.opacity(0.16)]
        case .slate:
            return [.gray.opacity(0.28), .blue.opacity(0.10)]
        case .rose:
            return [.pink.opacity(0.22), .red.opacity(0.12)]
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Label(question.mediaSource, systemImage: "person.crop.rectangle")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)

                Spacer()

                Text(question.mediaBadge)
                    .font(.caption.weight(.bold))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(.white.opacity(0.7), in: Capsule())
            }

            ZStack {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: palette,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(minHeight: 220)

                VStack(spacing: 12) {
                    Image(systemName: question.mediaSymbol)
                        .font(.system(size: 48))
                        .foregroundStyle(.primary)

                    Text(question.mediaHeadline)
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding(24)
            }

            Text("Demo visual for prototype. Replace with your real screenshot or photo later.")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
    }
}

private struct TimerBadgeView: View {
    let remainingTime: Int

    private var tint: Color {
        remainingTime <= 5 ? .pink : .indigo
    }

    var body: some View {
        Label("\(remainingTime)s", systemImage: "timer")
            .font(.headline)
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(tint.opacity(0.12), in: Capsule())
            .foregroundStyle(tint)
    }
}

struct PhotosGameView_Previews: PreviewProvider {
    static var previews: some View {
        PhotosGameView(viewModel: QuizViewModel())
    }
}
