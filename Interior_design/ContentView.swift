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
    
    var body: some View {
        ZStack {
            ARViewContainer(viewModel: viewModel, isPlacementMode: $viewModel.isPlacementMode)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                HStack {
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
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.8)]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .foregroundColor(.white)
                        .cornerRadius(25)
                        .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 2)
                    }
                    
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
                    
                    Spacer()
                    
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
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.red.opacity(0.8), Color.orange.opacity(0.8)]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .foregroundColor(.white)
                        .cornerRadius(25)
                        .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 2)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
            
            if viewModel.showModelPicker {
                VStack {
                    Spacer()
                    
                    VStack(spacing: 20) {
                        Text("Select Furniture")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        ForEach(viewModel.availableModels, id: \.self) { model in
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
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.white.opacity(0.15))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                        )
                                )
                                .foregroundColor(.white)
                            }
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
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.black.opacity(0.85))
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                            )
                    )
                    .padding(.horizontal, 30)
                    .padding(.bottom, 120)
                }
            }
            
            if viewModel.isPlacementMode {
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
                    .background(
                        Capsule()
                            .fill(Color.blue.opacity(0.9))
                            .overlay(
                                Capsule()
                                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
                            )
                    )
                    .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 2)
                    .padding(.top, 60)
                    
                    Spacer()
                    
                    // Cancel placement button
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
            
            if viewModel.showStats {
                VStack {
                    Spacer()
                    
                    VStack(spacing: 20) {
                        Text("Placement Statistics")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        VStack(spacing: 15) {
                            HStack {
                                Image(systemName: "cube.fill")
                                    .foregroundColor(.blue)
                                Text("Total Items Placed:")
                                    .foregroundColor(.white)
                                Spacer()
                                Text("\(viewModel.totalModelsPlaced)")
                                    .fontWeight(.bold)
                                    .foregroundColor(.green)
                            }
                            
                            HStack {
                                Image(systemName: "chair.fill")
                                    .foregroundColor(.orange)
                                Text("Chairs:")
                                    .foregroundColor(.white)
                                Spacer()
                                Text("\(viewModel.getModelCount(for: "chair"))")
                                    .fontWeight(.bold)
                                    .foregroundColor(.green)
                            }
                            
                            HStack {
                                Image(systemName: "table.furniture.fill")
                                    .foregroundColor(.brown)
                                Text("Tables:")
                                    .foregroundColor(.white)
                                Spacer()
                                Text("\(viewModel.getModelCount(for: "table"))")
                                    .fontWeight(.bold)
                                    .foregroundColor(.green)
                            }
                            
                            HStack {
                                Image(systemName: "eye.fill")
                                    .foregroundColor(.purple)
                                Text("Currently Visible:")
                                    .foregroundColor(.white)
                                Spacer()
                                Text("\(viewModel.placedModels.count)")
                                    .fontWeight(.bold)
                                    .foregroundColor(.green)
                            }
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
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.black.opacity(0.85))
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                            )
                    )
                    .padding(.horizontal, 30)
                    .padding(.bottom, 120)
                }
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
