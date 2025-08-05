//
//  ContentView.swift
//  Interior_design
//
//  Created by Parth Sinh on 04/08/25.
//  Enhanced with modern UI, analytics, and improved user experience

import SwiftUI
import ARKit
import RealityKit

struct ContentView: View {
    
    @StateObject private var viewModel = ARViewModel()
    
    // MARK: - Computed Properties for Button Styles
    private var blueGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.8)]),
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    private var redGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [Color.red.opacity(0.8), Color.orange.opacity(0.8)]),
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    private var modelPickerBackground: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color.black.opacity(0.85))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
            )
    }
    
    private var furnitureItemBackground: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.white.opacity(0.15))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
            )
    }
    
    private var placementInstructionBackground: some View {
        Capsule()
            .fill(Color.blue.opacity(0.9))
            .overlay(
                Capsule()
                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
            )
    }
    
    // MARK: - Button Components
    private var furnitureSelectionButton: some View {
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
    
    private var statisticsButton: some View {
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
    
    private var clearAllButton: some View {
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
        ZStack {
            ARViewContainer(viewModel: viewModel, isPlacementMode: $viewModel.isPlacementMode)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                HStack {
                    furnitureSelectionButton
                    statisticsButton
                    Spacer()
                    clearAllButton
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
            
            if viewModel.showModelPicker {
                ModelPickerView(viewModel: viewModel)
            }
            
            if viewModel.isPlacementMode {
                PlacementModeView(viewModel: viewModel)
            }
            
            if viewModel.showStats {
                StatisticsView(viewModel: viewModel)
            }
        }
        .onAppear {
            ARSession.shared.requestCameraPermission { granted in
                if !granted {
                    print("Camera permission denied")
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

// MARK: - Separate View Components

struct ModelPickerView: View {
    @ObservedObject var viewModel: ARViewModel
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 20) {
                Text("Select Furniture")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                ForEach(viewModel.availableModels, id: \.self) { model in
                    FurnitureItemView(model: model, viewModel: viewModel)
                }
                
                Button("Cancel") {
                    viewModel.showModelPicker = false
                }
                .font(.system(size: 16, weight: .medium))
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(Color.gray.opacity(0.3))
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding(25)
            .background(modelPickerBackground)
            .padding(.horizontal, 30)
            .padding(.bottom, 120)
        }
    }
    
    private var modelPickerBackground: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color.black.opacity(0.85))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
            )
    }
}

struct FurnitureItemView: View {
    let model: String
    @ObservedObject var viewModel: ARViewModel
    
    var body: some View {
        Button(action: {
            viewModel.selectModel(model)
        }) {
            HStack {
                Image(systemName: model == "chair" ? "chair.fill" : "table.furniture.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.blue)
                Text(model.capitalized)
                    .font(.system(size: 18, weight: .medium))
                Spacer()
                if viewModel.selectedModelName == model {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.system(size: 20))
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
            .background(furnitureItemBackground)
            .foregroundColor(.white)
        }
    }
    
    private var furnitureItemBackground: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.white.opacity(0.15))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
            )
    }
}

struct PlacementModeView: View {
    @ObservedObject var viewModel: ARViewModel
    
    var body: some View {
        VStack {
            VStack(spacing: 8) {
                HStack {
                    Image(systemName: "hand.tap.fill")
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                    Text("Tap to place \(viewModel.selectedModelName)")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                }
                
                Text("Look for flat surfaces")
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(placementInstructionBackground)
            .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 2)
            .padding(.top, 60)
            
            Spacer()
            
            Button(action: {
                viewModel.cancelPlacement()
            }) {
                HStack {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 16))
                    Text("Cancel")
                        .font(.system(size: 16, weight: .medium))
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(Color.gray.opacity(0.8))
                .foregroundColor(.white)
                .cornerRadius(25)
                .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 1)
            }
            .padding(.bottom, 140)
        }
    }
    
    private var placementInstructionBackground: some View {
        Capsule()
            .fill(Color.blue.opacity(0.9))
            .overlay(
                Capsule()
                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
            )
    }
}

struct StatisticsView: View {
    @ObservedObject var viewModel: ARViewModel
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 20) {
                Text("Placement Statistics")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                VStack(spacing: 15) {
                    StatisticRow(
                        icon: "cube.fill",
                        color: .blue,
                        title: "Total Items Placed:",
                        value: "\(viewModel.totalModelsPlaced)"
                    )
                    
                    StatisticRow(
                        icon: "chair.fill",
                        color: .orange,
                        title: "Chairs:",
                        value: "\(viewModel.getModelCount(for: "chair"))"
                    )
                    
                    StatisticRow(
                        icon: "table.furniture.fill",
                        color: .brown,
                        title: "Tables:",
                        value: "\(viewModel.getModelCount(for: "table"))"
                    )
                    
                    StatisticRow(
                        icon: "eye.fill",
                        color: .purple,
                        title: "Currently Visible:",
                        value: "\(viewModel.placedModels.count)"
                    )
                }
                .padding(.horizontal, 20)
                
                Button("Close") {
                    viewModel.showStats = false
                }
                .font(.system(size: 16, weight: .medium))
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(Color.gray.opacity(0.3))
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding(25)
            .background(statisticsBackground)
            .padding(.horizontal, 30)
            .padding(.bottom, 120)
        }
    }
    
    private var statisticsBackground: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color.black.opacity(0.85))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
            )
    }
}

struct StatisticRow: View {
    let icon: String
    let color: Color
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
            Text(title)
                .foregroundColor(.white)
            Spacer()
            Text(value)
                .fontWeight(.bold)
                .foregroundColor(.green)
        }
    }
}
