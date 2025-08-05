//
//  ARViewContainer.swift
//  Interior_design
//
//  Created by Parth Sinh on 04/08/25.
//  Enhanced with robust error handling, haptic feedback, and improved AR session management
//  Added simulator support and device detection

import SwiftUI
import ARKit
import RealityKit
import Combine

struct ARViewContainer: UIViewRepresentable {
    
    @ObservedObject var viewModel: ARViewModel
    @Binding var isPlacementMode: Bool
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero, cameraMode: .ar, automaticallyConfigureSession: false)
        
        // Check if running on simulator or if AR is supported
        #if targetEnvironment(simulator)
        // Running on simulator - don't start AR session but set up gestures
        print("Running on iOS Simulator - AR features disabled")
        
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:)))
        arView.addGestureRecognizer(tapGesture)
        
        context.coordinator.arView = arView
        context.coordinator.viewModel = viewModel
        
        return arView
        #else
        // Running on physical device
        guard ARWorldTrackingConfiguration.isSupported else {
            print("AR World Tracking not supported on this device")
            return arView
        }
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        configuration.environmentTexturing = .automatic
        configuration.isLightEstimationEnabled = true
        
        if ARWorldTrackingConfiguration.supportsFrameSemantics(.sceneDepth) {
            configuration.frameSemantics.insert(.sceneDepth)
        }
        
        arView.session.run(configuration)
        
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:)))
        arView.addGestureRecognizer(tapGesture)
        
        arView.session.delegate = context.coordinator
        context.coordinator.arView = arView
        context.coordinator.viewModel = viewModel
        
        return arView
        #endif
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        context.coordinator.isPlacementMode = isPlacementMode
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, ARSessionDelegate {
        var parent: ARViewContainer
        var arView: ARView?
        var viewModel: ARViewModel?
        var isPlacementMode: Bool = false
        
        init(_ parent: ARViewContainer) {
            self.parent = parent
        }
        
        @objc func handleTap(_ gesture: UITapGestureRecognizer) {
            guard isPlacementMode,
                  let arView = arView,
                  let viewModel = viewModel else { return }
            
            let location = gesture.location(in: arView)
            
            // Light haptic feedback on tap
            let selectionFeedback = UISelectionFeedbackGenerator()
            selectionFeedback.selectionChanged()
            
            #if targetEnvironment(simulator)
            // Simulator mode - simulate furniture placement
            print("Simulator mode: Simulating furniture placement")
            let simulatedPosition = SIMD3<Float>(0, 0, -1) // 1 meter in front
            viewModel.placeModel(at: simulatedPosition, with: nil)
            
            // Success haptic feedback for simulator
            let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
            feedbackGenerator.impactOccurred()
            return
            #else
            // Physical device mode - use real AR
            guard let raycastQuery = arView.makeRaycastQuery(from: location, allowing: .estimatedPlane, alignment: .any),
                  let raycastResult = arView.session.raycast(raycastQuery).first else {
                print("No surface detected at tap location")
                
                // Error haptic feedback
                let feedbackGenerator = UINotificationFeedbackGenerator()
                feedbackGenerator.notificationOccurred(.warning)
                return
            }
            
            placeFurnitureModel(at: raycastResult.worldTransform, in: arView, viewModel: viewModel)
            #endif
        }
        
        private func placeFurnitureModel(at transform: simd_float4x4, in arView: ARView, viewModel: ARViewModel) {
            let modelName = viewModel.selectedModelName
            
            guard let modelURL = Bundle.main.url(forResource: modelName, withExtension: "usdz"),
                  let modelEntity = try? ModelEntity.load(contentsOf: modelURL) else {
                print("Failed to load model: \(modelName)")
                
                // Haptic feedback for failure
                let feedbackGenerator = UINotificationFeedbackGenerator()
                feedbackGenerator.notificationOccurred(.error)
                return
            }
            
            let anchor = ARAnchor(name: "furniture_\(UUID())", transform: transform)
            arView.session.add(anchor: anchor)
            
            // Add physics and collision detection
            modelEntity.generateCollisionShapes(recursive: true)
            
            // Scale model appropriately
            let scaleFactor: Float = modelName == "chair" ? 0.8 : 1.0
            modelEntity.scale = SIMD3<Float>(scaleFactor, scaleFactor, scaleFactor)
            
            let anchorEntity = AnchorEntity(world: transform)
            anchorEntity.addChild(modelEntity)
            arView.scene.addAnchor(anchorEntity)
            
            let position = SIMD3<Float>(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
            viewModel.placeModel(at: position, with: anchor)
            
            // Success haptic feedback
            let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
            feedbackGenerator.impactOccurred()
            
            print("Placed \(modelName) at position: \(position)")
        }
        
        func session(_ session: ARSession, didFailWithError error: Error) {
            print("AR Session failed: \(error.localizedDescription)")
            
            // Handle specific error cases
            if let arError = error as? ARError {
                switch arError.code {
                case .cameraUnauthorized:
                    print("Camera access denied")
                case .unsupportedConfiguration:
                    print("AR configuration not supported")
                case .sensorUnavailable:
                    print("AR sensors unavailable")
                case .sensorFailed:
                    print("AR sensor failed")
                default:
                    print("Other AR error: \(arError.localizedDescription)")
                }
            }
        }
        
        func sessionWasInterrupted(_ session: ARSession) {
            print("AR Session interrupted - app backgrounded or incoming call")
        }
        
        func sessionInterruptionEnded(_ session: ARSession) {
            print("AR Session interruption ended - resuming AR")
            
            // Restart the session if needed
            guard let arView = arView else { return }
            let configuration = ARWorldTrackingConfiguration()
            configuration.planeDetection = [.horizontal, .vertical]
            configuration.environmentTexturing = .automatic
            configuration.isLightEstimationEnabled = true
            
            if ARWorldTrackingConfiguration.supportsFrameSemantics(.sceneDepth) {
                configuration.frameSemantics.insert(.sceneDepth)
            }
            
            arView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        }
        
        func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
            print("Anchors added: \(anchors.count)")
        }
        
        func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
            // Handle anchor updates if needed
        }
        
        func session(_ session: ARSession, didRemove anchors: [ARAnchor]) {
            print("Anchors removed: \(anchors.count)")
        }
    }
} 
