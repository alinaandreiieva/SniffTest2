//
//  QuizModels.swift
//  SniffTest
//
//  Created by Alina Andreieva on 21/4/26.
//

import Foundation

enum AppTab: Hashable {
    case quiz
    case checker
    case legal
    case profile
}

enum QuizLevel: String, CaseIterable, Identifiable {
    case beginner
    case intermediate
    case advanced

    var id: String { rawValue }

    var title: String {
        switch self {
        case .beginner:
            return "Beginner"
        case .intermediate:
            return "Intermediate"
        case .advanced:
            return "Advanced"
        }
    }

    var subtitle: String {
        switch self {
        case .beginner:
            return "Spot the basics with simple true or false decisions."
        case .intermediate:
            return "Name the disinformation technique behind the post."
        case .advanced:
            return "Race against the timer and judge whether each image is real or AI-generated."
        }
    }

    var completionTitle: String {
        switch self {
        case .beginner:
            return "Beginner complete"
        case .intermediate:
            return "Intermediate complete"
        case .advanced:
            return "Advanced complete"
        }
    }
}

enum DisinformationCategory: String, CaseIterable, Identifiable {
    case falseContext = "False context"
    case manipulatedContent = "Manipulated content"
    case satireOrParody = "Satire or parody"
    case imposterContent = "Imposter content"

    var id: String { rawValue }
}

enum QuizAnswer: Equatable, Hashable, Identifiable {
    case boolean(Bool)
    case category(DisinformationCategory)

    var id: String {
        switch self {
        case .boolean(let value):
            return value ? "true" : "false"
        case .category(let category):
            return category.rawValue
        }
    }

    var label: String {
        switch self {
        case .boolean(let value):
            return value ? "True" : "False"
        case .category(let category):
            return category.rawValue
        }
    }
}

enum QuestionMode {
    case trueFalse(correctAnswer: Bool)
    case category(correctCategory: DisinformationCategory)
}

enum QuestionTone {
    case sky
    case amber
    case mint
    case coral
    case violet
    case slate
    case rose
}

struct BooleanAnswerLabels {
    let trueLabel: String
    let falseLabel: String
}

struct QuizQuestion: Identifiable {
    let id = UUID()
    let title: String
    let detail: String
    let mediaSymbol: String
    let mediaHeadline: String
    let mediaSource: String
    let mediaBadge: String
    let mediaAssetName: String?
    let tone: QuestionTone
    let level: QuizLevel
    let mode: QuestionMode
    let explanation: String
    let booleanAnswerLabels: BooleanAnswerLabels?

    init(
        title: String,
        detail: String,
        mediaSymbol: String,
        mediaHeadline: String,
        mediaSource: String,
        mediaBadge: String,
        mediaAssetName: String? = nil,
        tone: QuestionTone,
        level: QuizLevel,
        mode: QuestionMode,
        explanation: String,
        booleanAnswerLabels: BooleanAnswerLabels? = nil
    ) {
        self.title = title
        self.detail = detail
        self.mediaSymbol = mediaSymbol
        self.mediaHeadline = mediaHeadline
        self.mediaSource = mediaSource
        self.mediaBadge = mediaBadge
        self.mediaAssetName = mediaAssetName
        self.tone = tone
        self.level = level
        self.mode = mode
        self.explanation = explanation
        self.booleanAnswerLabels = booleanAnswerLabels
    }

    var answers: [QuizAnswer] {
        switch mode {
        case .trueFalse:
            return [.boolean(true), .boolean(false)]
        case .category:
            return DisinformationCategory.allCases.map(QuizAnswer.category)
        }
    }

    func label(for answer: QuizAnswer) -> String {
        switch answer {
        case .boolean(let value):
            if let booleanAnswerLabels {
                return value ? booleanAnswerLabels.trueLabel : booleanAnswerLabels.falseLabel
            }
            return value ? "True" : "False"
        case .category(let category):
            return category.rawValue
        }
    }

    func isCorrect(_ answer: QuizAnswer) -> Bool {
        switch (mode, answer) {
        case let (.trueFalse(correctAnswer), .boolean(value)):
            return correctAnswer == value
        case let (.category(correctCategory), .category(selectedCategory)):
            return correctCategory == selectedCategory
        default:
            return false
        }
    }
}

enum FeedbackKind {
    case success
    case warning
    case timeout
}

struct AnswerFeedback: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let kind: FeedbackKind
}

enum QuizContent {
    static let beginnerQuestions: [QuizQuestion] = [
        QuizQuestion(
            title: "A post says you must share it within 10 minutes to keep your bank account safe.",
            detail: "There is no source, no official logo, and the message pushes urgency.",
            mediaSymbol: "exclamationmark.bubble.fill",
            mediaHeadline: "Forward this now or your account may be frozen tonight.",
            mediaSource: "Forwarded many times",
            mediaBadge: "Urgent",
            tone: .coral,
            level: .beginner,
            mode: .trueFalse(correctAnswer: false),
            explanation: "Urgency without a trustworthy source is a common red flag. Real security notices point people to official channels instead of asking for viral sharing."
        ),
        QuizQuestion(
            title: "An emergency weather update links to the local government website and matches the official social account.",
            detail: "The post includes a timestamp and a direct link to the public alert page.",
            mediaSymbol: "cloud.bolt.rain.fill",
            mediaHeadline: "Storm alert in effect until 18:00. Check the city warning page for updates.",
            mediaSource: "City Weather Office",
            mediaBadge: "Verified",
            tone: .sky,
            level: .beginner,
            mode: .trueFalse(correctAnswer: true),
            explanation: "This is the kind of evidence you want to see: a known source, a verifiable link, and details you can cross-check on the official site."
        ),
        QuizQuestion(
            title: "A screenshot claims a new school policy starts tomorrow, but it has no date, no sender, and no school website.",
            detail: "Friends are reposting it as if it were confirmed.",
            mediaSymbol: "graduationcap.fill",
            mediaHeadline: "New school rule starts tomorrow. Everyone must bring printed forms.",
            mediaSource: "Screenshot shared in class chat",
            mediaBadge: "No source",
            tone: .amber,
            level: .beginner,
            mode: .trueFalse(correctAnswer: false),
            explanation: "When a claim affects the public, missing dates and missing sourcing matter. A quick check against the school's official website or parent portal would come first."
        ),
        QuizQuestion(
            title: "A public health graphic includes the agency logo, a publication date, and the same wording appears on the agency website.",
            detail: "The visual is polished, but more importantly it is easy to verify independently.",
            mediaSymbol: "cross.case.fill",
            mediaHeadline: "Vaccination clinic open Saturday. Walk-ins accepted from 09:00 to 14:00.",
            mediaSource: "Regional Health Agency",
            mediaBadge: "Official",
            tone: .mint,
            level: .beginner,
            mode: .trueFalse(correctAnswer: true),
            explanation: "Good design alone does not prove accuracy, but here the message also has the things that matter: a named source, a date, and an easy way to confirm it."
        ),
        QuizQuestion(
            title: "A viral post says a supermarket is giving away free gift cards, but the only link leads to an unfamiliar survey site.",
            detail: "The brand name is used in the image, but the web address does not match the company's real website.",
            mediaSymbol: "gift.fill",
            mediaHeadline: "Claim your 100 euro store voucher before midnight.",
            mediaSource: "Sponsored-looking repost",
            mediaBadge: "Suspicious link",
            tone: .violet,
            level: .beginner,
            mode: .trueFalse(correctAnswer: false),
            explanation: "A recognizable brand name does not make the claim trustworthy. If the link goes to an unrelated domain, that is a strong sign the post is misleading or a scam."
        )
    ]

    static let intermediateQuestions: [QuizQuestion] = [
        QuizQuestion(
            title: "A real protest photo from 2019 is reposted as if it happened this morning.",
            detail: "The image itself is real, but the timing and event description are wrong.",
            mediaSymbol: "flag.pattern.checkered",
            mediaHeadline: "Crowds gather downtown this morning after emergency vote.",
            mediaSource: "Trending repost account",
            mediaBadge: "Old photo",
            tone: .violet,
            level: .intermediate,
            mode: .category(correctCategory: .falseContext),
            explanation: "This is false context: authentic material is used, but it is framed in a misleading way to change what people think it proves."
        ),
        QuizQuestion(
            title: "A celebrity image has been edited to add a fake sign in the background.",
            detail: "The original photo exists, but a visual element was changed to push a false claim.",
            mediaSymbol: "sparkles.tv.fill",
            mediaHeadline: "Celebrity appears at event holding a message they never endorsed.",
            mediaSource: "Entertainment leak page",
            mediaBadge: "Edited image",
            tone: .rose,
            level: .intermediate,
            mode: .category(correctCategory: .manipulatedContent),
            explanation: "This is manipulated content because the original media was altered. Even a small edit can dramatically change the meaning."
        ),
        QuizQuestion(
            title: "An account copies a major news outlet's logo, but the username has one extra letter and no verification.",
            detail: "The posts are written to look official at a glance.",
            mediaSymbol: "newspaper.fill",
            mediaHeadline: "Breaking: New travel restrictions begin tonight, sources say.",
            mediaSource: "Daily Globee",
            mediaBadge: "Lookalike account",
            tone: .slate,
            level: .intermediate,
            mode: .category(correctCategory: .imposterContent),
            explanation: "This is imposter content. The goal is to borrow trust from a familiar brand while presenting false or misleading information."
        ),
        QuizQuestion(
            title: "A comedy website posts an absurd 'breaking story' and readers share the screenshot without noticing the publication.",
            detail: "The site is known for jokes and parody headlines.",
            mediaSymbol: "theatermasks.fill",
            mediaHeadline: "Government to replace all traffic lights with mood rings by July.",
            mediaSource: "The Daily Onion Ring",
            mediaBadge: "Satire",
            tone: .amber,
            level: .intermediate,
            mode: .category(correctCategory: .satireOrParody),
            explanation: "This is satire or parody. The content may not be intended as factual reporting, but it can still mislead when removed from its original context."
        ),
        QuizQuestion(
            title: "A clip from a years-old interview is reposted with a new caption claiming it is today's statement about a different issue.",
            detail: "The video is genuine, but the caption changes what viewers think they are watching.",
            mediaSymbol: "video.fill",
            mediaHeadline: "Watch what the minister admitted this afternoon on live TV.",
            mediaSource: "Politics rapid updates",
            mediaBadge: "Misleading caption",
            tone: .sky,
            level: .intermediate,
            mode: .category(correctCategory: .falseContext),
            explanation: "This is another false context example: the media is real, but the surrounding framing creates a false takeaway."
        ),
        QuizQuestion(
            title: "A fake charity page copies the name and visual style of a real relief organization to collect donations.",
            detail: "The branding is close enough to confuse people, but the account is not operated by the real group.",
            mediaSymbol: "heart.text.square.fill",
            mediaHeadline: "Donate here to the official emergency response fund.",
            mediaSource: "Relief Hands Worldwidee",
            mediaBadge: "Copied identity",
            tone: .coral,
            level: .intermediate,
            mode: .category(correctCategory: .imposterContent),
            explanation: "This is imposter content because the post is pretending to come from a trusted organization in order to borrow its credibility."
        )
    ]

    static let advancedQuestions: [QuizQuestion] = [
        QuizQuestion(
            title: "Real photo or AI image?",
            detail: "Use only the visual clues in the image and decide whether it is authentic or AI-generated.",
            mediaSymbol: "photo",
            mediaHeadline: "Advanced image challenge",
            mediaSource: "Visual-only round",
            mediaBadge: "Image 1",
            mediaAssetName: "advanced-1",
            tone: .slate,
            level: .advanced,
            mode: .trueFalse(correctAnswer: true),
            explanation: "This image is real.",
            booleanAnswerLabels: BooleanAnswerLabels(trueLabel: "Real", falseLabel: "Fake (AI)")
        ),
        QuizQuestion(
            title: "Real photo or AI image?",
            detail: "Look for subtle issues with texture, depth, reflections, and repeated details before answering.",
            mediaSymbol: "photo",
            mediaHeadline: "Advanced image challenge",
            mediaSource: "Visual-only round",
            mediaBadge: "Image 2",
            mediaAssetName: "advanced-2",
            tone: .slate,
            level: .advanced,
            mode: .trueFalse(correctAnswer: true),
            explanation: "This image is real.",
            booleanAnswerLabels: BooleanAnswerLabels(trueLabel: "Real", falseLabel: "Fake (AI)")
        ),
        QuizQuestion(
            title: "Real photo or AI image?",
            detail: "Look for subtle issues with texture, depth, reflections, and repeated details before answering.",
            mediaSymbol: "photo",
            mediaHeadline: "Advanced image challenge",
            mediaSource: "Visual-only round",
            mediaBadge: "Image 3",
            mediaAssetName: "advanced-3",
            tone: .slate,
            level: .advanced,
            mode: .trueFalse(correctAnswer: false),
            explanation: "This image is AI-generated.",
            booleanAnswerLabels: BooleanAnswerLabels(trueLabel: "Real", falseLabel: "Fake (AI)")
        ),
        QuizQuestion(
            title: "Real photo or AI image?",
            detail: "Look for subtle issues with texture, depth, reflections, and repeated details before answering.",
            mediaSymbol: "photo",
            mediaHeadline: "Advanced image challenge",
            mediaSource: "Visual-only round",
            mediaBadge: "Image 4",
            mediaAssetName: "advanced-4",
            tone: .slate,
            level: .advanced,
            mode: .trueFalse(correctAnswer: false),
            explanation: "This image is AI-generated.",
            booleanAnswerLabels: BooleanAnswerLabels(trueLabel: "Real", falseLabel: "Fake (AI)")
        ),
        QuizQuestion(
            title: "Real photo or AI image?",
            detail: "Look for subtle issues with texture, depth, reflections, and repeated details before answering.",
            mediaSymbol: "photo",
            mediaHeadline: "Advanced image challenge",
            mediaSource: "Visual-only round",
            mediaBadge: "Image 5",
            mediaAssetName: "advanced-5",
            tone: .slate,
            level: .advanced,
            mode: .trueFalse(correctAnswer: true),
            explanation: "This image is real.",
            booleanAnswerLabels: BooleanAnswerLabels(trueLabel: "Real", falseLabel: "Fake (AI)")
        ),
        QuizQuestion(
            title: "Real photo or AI image?",
            detail: "Look for subtle issues with texture, depth, reflections, and repeated details before answering.",
            mediaSymbol: "photo",
            mediaHeadline: "Advanced image challenge",
            mediaSource: "Visual-only round",
            mediaBadge: "Image 6",
            mediaAssetName: "advanced-6",
            tone: .slate,
            level: .advanced,
            mode: .trueFalse(correctAnswer: false),
            explanation: "This image is AI-generated.",
            booleanAnswerLabels: BooleanAnswerLabels(trueLabel: "Real", falseLabel: "Fake (AI)")
        ),
        QuizQuestion(
            title: "Real photo or AI image?",
            detail: "Look for subtle issues with texture, depth, reflections, and repeated details before answering.",
            mediaSymbol: "photo",
            mediaHeadline: "Advanced image challenge",
            mediaSource: "Visual-only round",
            mediaBadge: "Image 7",
            mediaAssetName: "advanced-7",
            tone: .slate,
            level: .advanced,
            mode: .trueFalse(correctAnswer: true),
            explanation: "This image is real.",
            booleanAnswerLabels: BooleanAnswerLabels(trueLabel: "Real", falseLabel: "Fake (AI)")
        ),
        QuizQuestion(
            title: "Real photo or AI image?",
            detail: "Look for subtle issues with texture, depth, reflections, and repeated details before answering.",
            mediaSymbol: "photo",
            mediaHeadline: "Advanced image challenge",
            mediaSource: "Visual-only round",
            mediaBadge: "Image 8",
            mediaAssetName: "advanced-8",
            tone: .slate,
            level: .advanced,
            mode: .trueFalse(correctAnswer: false),
            explanation: "This image is AI-generated.",
            booleanAnswerLabels: BooleanAnswerLabels(trueLabel: "Real", falseLabel: "Fake (AI)")
        ),
        QuizQuestion(
            title: "Real photo or AI image?",
            detail: "Look for subtle issues with texture, depth, reflections, and repeated details before answering.",
            mediaSymbol: "photo",
            mediaHeadline: "Advanced image challenge",
            mediaSource: "Visual-only round",
            mediaBadge: "Image 9",
            mediaAssetName: "advanced-9",
            tone: .slate,
            level: .advanced,
            mode: .trueFalse(correctAnswer: true),
            explanation: "This image is real.",
            booleanAnswerLabels: BooleanAnswerLabels(trueLabel: "Real", falseLabel: "Fake (AI)")
        ),
        QuizQuestion(
            title: "Real photo or AI image?",
            detail: "Look for subtle issues with texture, depth, reflections, and repeated details before answering.",
            mediaSymbol: "photo",
            mediaHeadline: "Advanced image challenge",
            mediaSource: "Visual-only round",
            mediaBadge: "Image 10",
            mediaAssetName: "advanced-10",
            tone: .slate,
            level: .advanced,
            mode: .trueFalse(correctAnswer: false),
            explanation: "This image is AI-generated.",
            booleanAnswerLabels: BooleanAnswerLabels(trueLabel: "Real", falseLabel: "Fake (AI)")
        )
    ]
}
