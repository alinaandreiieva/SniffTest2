//
//  OnboardingView.swift
//  SniffTest
//
//  Created by Alina Andreieva on 21/4/26.
//

import SwiftUI

struct OnboardingView: View {
    let onStart: () -> Void

    var body: some View {
        ZStack {
            AppTheme.background
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 24) {
                Spacer()

                VStack(alignment: .leading, spacing: 12) {
                    Text("Detect Disinformation")
                        .font(.largeTitle.bold())

                    Text("Train yourself to spot misleading content before you share it.")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                }

                VStack(alignment: .leading, spacing: 16) {
                    RuleRow(
                        icon: "1.circle.fill",
                        title: "Beginner",
                        message: "Read a short post and decide whether it feels trustworthy: true or false."
                    )
                    RuleRow(
                        icon: "2.circle.fill",
                        title: "Intermediate",
                        message: "Name the type of disinformation, like false context, parody, or manipulated content."
                    )
                    RuleRow(
                        icon: "3.circle.fill",
                        title: "Advanced",
                        message: "Answer a timed mix of beginner and intermediate questions before the clock runs out."
                    )
                    RuleRow(
                        icon: "text.bubble.fill",
                        title: "After every answer",
                        message: "You will get a friendly explanation banner so the app teaches, not just scores."
                    )
                }
                .padding(24)
                .background(.white, in: RoundedRectangle(cornerRadius: 28, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .stroke(.indigo, lineWidth: 1)
                )

                Spacer()

                Button(action: onStart) {
                    Text("Start")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                }
                .appPrimaryButtonStyle()
            }
            .padding(24)
        }
    }
}

private struct RuleRow: View {
    let icon: String
    let title: String
    let message: String

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(.indigo)
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)

                Text(message)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(onStart: {})
    }
}
