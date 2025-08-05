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
                            Image(systemName: "cube.box")
                            Text(viewModel.selectedModelName.capitalized)
                        }
                        .padding()
                        .background(Color.black.opacity(0.7))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    
                    Spacer()
                    
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
