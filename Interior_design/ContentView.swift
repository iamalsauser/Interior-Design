//
//  ContentView.swift
//  Interior_design
//
//  Created by Parth Sinh on 04/08/25.
//

import SwiftUI
import ARKit
import RealityKit

// MARK: - Main Content View
// Main UI containing AR view and control overlays
struct ContentView: View {
    
    // MARK: - State Management
    @StateObject private var viewModel = ARViewModel()
    
    var body: some View {
        ZStack {
            // MARK: - AR View Background
            // Full-screen AR view for room scanning and furniture placement
            ARViewContainer(viewModel: viewModel, isPlacementMode: $viewModel.isPlacementMode)
                .edgesIgnoringSafeArea(.all)
            
            // MARK: - Control Overlay
            VStack {
                Spacer()
                
                // MARK: - Bottom Control Panel
                HStack {
                    // MARK: - Model Selection Button
                    Button(action: {
                        viewModel.toggleModelPicker()
                    }) {
                        HStack {
                            Image(systemName: "cube.box")
                            Text(viewModel.selectedModelName.capitalized)
                        }
                        .padding()
                        .background(Color.black.opacity(0.7))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    
                    Spacer()
                    
                    // MARK: - Remove All Button
                    Button(action: {
                        viewModel.removeAllModels()
                    }) {
                        HStack {
                            Image(systemName: "trash")
                            Text("Clear All")
                        }
                        .padding()
                        .background(Color.red.opacity(0.7))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
            
            // MARK: - Model Picker Sheet
            if viewModel.showModelPicker {
                VStack {
                    Spacer()
                    
                    VStack(spacing: 15) {
                        Text("Select Furniture")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        ForEach(viewModel.availableModels, id: \.self) { model in
                            Button(action: {
                                viewModel.selectModel(model)
                            }) {
                                HStack {
                                    Image(systemName: "cube.box.fill")
                                    Text(model.capitalized)
                                    Spacer()
                                    if viewModel.selectedModelName == model {
                                        Image(systemName: "checkmark")
                                    }
                                }
                                .padding()
                                .background(Color.black.opacity(0.8))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                            }
                        }
                        
                        Button("Cancel") {
                            viewModel.showModelPicker = false
                        }
                        .padding()
                        .background(Color.gray.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                    .padding()
                    .background(Color.black.opacity(0.6))
                    .cornerRadius(15)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 100)
                }
            }
            
            // MARK: - Placement Mode Indicator
            if viewModel.isPlacementMode {
                VStack {
                    Text("Tap to place \(viewModel.selectedModelName)")
                        .padding()
                        .background(Color.blue.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.top, 50)
                    
                    Spacer()
                }
            }
        }
        .onAppear {
            // MARK: - App Initialization
            // Request camera permissions and initialize AR
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
