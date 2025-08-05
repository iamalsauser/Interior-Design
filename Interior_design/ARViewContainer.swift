//
//  ARViewContainer.swift
//  Interior_design
//
//  Created by Parth Sinh on 04/08/25.
//

import SwiftUI
import ARKit
import RealityKit
import Combine

// MARK: - AR View Container
// Wraps ARKit's ARView for use in SwiftUI
struct ARViewContainer: UIViewRepresentable {
    
    // MARK: - Properties
    @ObservedObject var viewModel: ARViewModel
    @Binding var isPlacementMode: Bool
    
    // MARK: - UIViewRepresentable Implementation
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero, cameraMode: .ar, automaticallyConfigureSession: false)
        
        // MARK: - AR Configuration
        // Configure AR session for room scanning and surface detection
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        configuration.environmentTexturing = .automatic
        configuration.isLightEstimationEnabled = true
        
        // Enable occlusion if supported
        if ARWorldTrackingConfiguration.supportsFrameSemantics(.sceneDepth) {
            configuration.frameSemantics.insert(.sceneDepth)
        }
        
        arView.session.run(configuration)
        
        // MARK: - Tap Gesture Setup
        // Add tap gesture for furniture placement
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:)))
        arView.addGestureRecognizer(tapGesture)
        
        // MARK: - Session Delegate
        arView.session.delegate = context.coordinator
        context.coordinator.arView = arView
        context.coordinator.viewModel = viewModel
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        // Update AR view when placement mode changes
        context.coordinator.isPlacementMode = isPlacementMode
    }
    
    // MARK: - Coordinator
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // MARK: - Coordinator Class
    // Handles AR session events and tap gestures
    class Coordinator: NSObject, ARSessionDelegate {
        var parent: ARViewContainer
        var arView: ARView?
        var viewModel: ARViewModel?
        var isPlacementMode: Bool = false
        
        init(_ parent: ARViewContainer) {
            self.parent = parent
        }
        
        // MARK: - Tap Handling
        // Handles tap gestures for furniture placement
        @objc func handleTap(_ gesture: UITapGestureRecognizer) {
            guard isPlacementMode,
                  let arView = arView,
                  let viewModel = viewModel else { return }
            
            let location = gesture.location(in: arView)
            
            // Perform raycast to detect surfaces
            guard let raycastQuery = arView.makeRaycastQuery(from: location, allowing: .estimatedPlane, alignment: .any),
                  let raycastResult = arView.session.raycast(raycastQuery).first else {
                print("No surface detected at tap location")
                return
            }
            
            // MARK: - Model Placement
            // Place the selected furniture model at the tapped location
            placeFurnitureModel(at: raycastResult.worldTransform, in: arView, viewModel: viewModel)
        }
        
        // MARK: - Furniture Placement
        // Loads and places the selected USDZ model
        private func placeFurnitureModel(at transform: simd_float4x4, in arView: ARView, viewModel: ARViewModel) {
            let modelName = viewModel.selectedModelName
            
            // Load USDZ model from app bundle
            guard let modelURL = Bundle.main.url(forResource: modelName, withExtension: "usdz"),
                  let modelEntity = try? ModelEntity.load(contentsOf: modelURL) else {
                print("Failed to load model: \(modelName)")
                return
            }
            
            // Create anchor for the model
            let anchor = ARAnchor(name: "furniture_\(UUID())", transform: transform)
            arView.session.add(anchor: anchor)
            
            // Add model to scene
            modelEntity.generateCollisionShapes(recursive: true)
            arView.scene.addAnchor(AnchorEntity(anchor: anchor))
            anchor.addChild(modelEntity)
            
            // Update view model
            let position = SIMD3<Float>(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
            viewModel.placeModel(at: position, with: anchor)
            
            print("Placed \(modelName) at position: \(position)")
        }
        
        // MARK: - AR Session Delegate
        // Handles AR session updates and errors
        func session(_ session: ARSession, didFailWithError error: Error) {
            print("AR Session failed: \(error.localizedDescription)")
        }
        
        func sessionWasInterrupted(_ session: ARSession) {
            print("AR Session interrupted")
        }
        
        func sessionInterruptionEnded(_ session: ARSession) {
            print("AR Session interruption ended")
        }
    }
} 