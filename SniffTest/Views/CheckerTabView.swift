//
//  CheckerTabView.swift
//  SniffTest
//
//  Created by Alina Andreieva on 21/4/26.
//

import SwiftUI

struct CheckerTabView: View {
    var body: some View {
        NavigationStack {
            ContentUnavailableView(
                "Checker",
                systemImage: "checkmark.shield",
                description: Text("Prototype placeholder for the future checker flow.")
            )
        }
    }
}
