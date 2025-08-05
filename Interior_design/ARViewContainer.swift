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

struct ARViewContainer: UIViewRepresentable {
    
    @ObservedObject var viewModel: ARViewModel
    @Binding var isPlacementMode: Bool
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero, cameraMode: .ar, automaticallyConfigureSession: false)
        
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
            
            guard let raycastQuery = arView.makeRaycastQuery(from: location, allowing: .estimatedPlane, alignment: .any),
                  let raycastResult = arView.session.raycast(raycastQuery).first else {
                print("No surface detected at tap location")
                return
            }
            
            placeFurnitureModel(at: raycastResult.worldTransform, in: arView, viewModel: viewModel)
        }
        
        private func placeFurnitureModel(at transform: simd_float4x4, in arView: ARView, viewModel: ARViewModel) {
            let modelName = viewModel.selectedModelName
            
            guard let modelURL = Bundle.main.url(forResource: modelName, withExtension: "usdz"),
                  let modelEntity = try? ModelEntity.load(contentsOf: modelURL) else {
                print("Failed to load model: \(modelName)")
                return
            }
            
            let anchor = ARAnchor(name: "furniture_\(UUID())", transform: transform)
            arView.session.add(anchor: anchor)
            
            modelEntity.generateCollisionShapes(recursive: true)
            arView.scene.addAnchor(AnchorEntity(anchor: anchor))
            anchor.addChild(modelEntity)
            
            let position = SIMD3<Float>(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
            viewModel.placeModel(at: position, with: anchor)
            
            print("Placed \(modelName) at position: \(position)")
        }
        
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