//
//  ProfileTabView.swift
//  SniffTest
//
//  Created by Alina Andreieva on 21/4/26.
//

import SwiftUI

struct ProfileTabView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.background
                    .ignoresSafeArea()

                ContentUnavailableView(
                    "Profile",
                    systemImage: "person.crop.circle",
                    description: Text("Prototype placeholder for profile details, settings, and progress.")
                )
            }
        }
    }
}
