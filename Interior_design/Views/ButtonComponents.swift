//
//  ButtonComponents.swift
//  Interior_design
//
//  Created by Parth Sinh on 05/08/25.
//  Reusable button components and styles

import SwiftUI

// MARK: - Button Style Extensions
extension ContentView {
    var blueGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.8)]),
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    var redGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [Color.red.opacity(0.8), Color.orange.opacity(0.8)]),
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}

// MARK: - Button Components
struct FurnitureSelectionButton: View {
    @ObservedObject var viewModel: ARViewModel
    let blueGradient: LinearGradient
    
    var body: some View {
        Button(action: {
            viewModel.toggleModelPicker()
        }) {
            HStack {
                Image(systemName: "cube.box.fill")
                    .font(.system(size: 16, weight: .semibold))
                Text(viewModel.selectedModelName.capitalized)
                    .font(.system(size: 16, weight: .medium))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(blueGradient)
            .foregroundColor(.white)
            .cornerRadius(25)
            .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 2)
        }
    }
}

struct StatisticsButton: View {
    @ObservedObject var viewModel: ARViewModel
    
    var body: some View {
        Button(action: {
            viewModel.toggleStats()
        }) {
            Image(systemName: "chart.bar.fill")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .padding(12)
                .background(Color.green.opacity(0.8))
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 1)
        }
    }
}

struct ClearAllButton: View {
    @ObservedObject var viewModel: ARViewModel
    let redGradient: LinearGradient
    
    var body: some View {
        Button(action: {
            viewModel.removeAllModels()
        }) {
            HStack {
                Image(systemName: "trash.fill")
                    .font(.system(size: 16, weight: .semibold))
                Text("Clear All")
                    .font(.system(size: 16, weight: .medium))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(redGradient)
            .foregroundColor(.white)
            .cornerRadius(25)
            .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 2)
        }
    }
}
