//
//  Interior_designApp.swift
//  Interior_design
//
//  Created by Parth Sinh on 04/08/25.
//

import SwiftUI

@main
struct Interior_designApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark) // Force dark mode for better AR experience
                .onAppear {
                    setupAppearance()
                }
        }
    }
    
    private func setupAppearance() {
        // Customize navigation bar appearance
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor.clear
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
        // Set status bar style
        UIApplication.shared.setStatusBarStyle(.lightContent, animated: false)
    }
}
