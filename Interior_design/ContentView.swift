//
//  ContentView.swift
//  Interior_design
//
//  Created by Parth Sinh on 04/08/25.
//  Enhanced with modern UI, analytics, and improved user experience
//  Refactored into separate components for better maintainability

import SwiftUI
import ARKit
import RealityKit
import AVFoundation

struct ContentView: View {
    @StateObject private var viewModel = ARViewModel()
    
    var body: some View {
        ZStack {
            ARViewContainer(viewModel: viewModel, isPlacementMode: $viewModel.isPlacementMode)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                HStack {
                    FurnitureSelectionButton(viewModel: viewModel, blueGradient: blueGradient)
                    StatisticsButton(viewModel: viewModel)
                    Spacer()
                    ClearAllButton(viewModel: viewModel, redGradient: redGradient)
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
            requestCameraPermission()
        }
    }
    
    private func requestCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            // Camera access already granted
            break
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if !granted {
                    print("Camera permission denied")
                }
            }
        case .denied, .restricted:
            print("Camera access denied or restricted")
        @unknown default:
            break
        }
    }
}

#Preview {
    ContentView()
}
