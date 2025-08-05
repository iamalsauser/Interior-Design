//
//  ContentView.swift
//  Interior_design
//
//  Created by Parth Sinh on 04/08/25.
//

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
