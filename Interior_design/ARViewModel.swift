//
//  ARViewModel.swift
//  Interior_design
//
//  Created by Parth Sinh on 04/08/25.
//

import SwiftUI
import Combine
import RealityKit

// MARK: - AR View Model
// This class manages the AR experience state using MVVM pattern with Combine
class ARViewModel: ObservableObject {
    
    // MARK: - Published Properties
    // These properties automatically update the UI when changed
    @Published var selectedModelName: String = "chair"
    @Published var isPlacementMode: Bool = false
    @Published var placedModels: [ARModel] = []
    @Published var showModelPicker: Bool = false
    
    // MARK: - Available Models
    // Simple list of available furniture models
    let availableModels = ["chair", "table"]
    
    // MARK: - Model Selection
    func selectModel(_ modelName: String) {
        selectedModelName = modelName
        isPlacementMode = true
        showModelPicker = false
    }
    
    // MARK: - Model Placement
    func placeModel(at position: SIMD3<Float>, with anchor: ARAnchor?) {
        let newModel = ARModel(
            name: selectedModelName,
            position: position,
            anchor: anchor
        )
        placedModels.append(newModel)
        isPlacementMode = false
    }
    
    // MARK: - Model Removal
    func removeModel(_ model: ARModel) {
        if let index = placedModels.firstIndex(where: { $0.id == model.id }) {
            placedModels.remove(at: index)
        }
    }
    
    func removeAllModels() {
        placedModels.removeAll()
    }
    
    // MARK: - UI State Management
    func toggleModelPicker() {
        showModelPicker.toggle()
    }
    
    func cancelPlacement() {
        isPlacementMode = false
    }
}

// MARK: - AR Model Data Structure
// Represents a placed 3D model in the AR scene
struct ARModel: Identifiable {
    let id = UUID()
    let name: String
    let position: SIMD3<Float>
    let anchor: ARAnchor?
    var entity: Entity?
} 