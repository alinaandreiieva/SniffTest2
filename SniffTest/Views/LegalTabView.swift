//
//  LegalTabView.swift
//  SniffTest
//
//  Created by Alina Andreieva on 21/4/26.
//

import SwiftUI

struct LegalTabView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.background
                    .ignoresSafeArea()

                ContentUnavailableView(
                    "Legal",
                    systemImage: "doc.text",
                    description: Text("Prototype placeholder for legal guidance and references.")
                )
            }
        }
    }
}
