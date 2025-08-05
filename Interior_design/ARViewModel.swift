//
//  ARViewModel.swift
//  Interior_design
//
//  Created by Parth Sinh on 04/08/25.
//

import SwiftUI
import Combine
import RealityKit

class ARViewModel: ObservableObject {
    
    @Published var selectedModelName: String = "chair"
    @Published var isPlacementMode: Bool = false
    @Published var placedModels: [ARModel] = []
    @Published var showModelPicker: Bool = false
    @Published var totalModelsPlaced: Int = 0
    @Published var showStats: Bool = false
    
    let availableModels = ["chair", "table"]
    
    func selectModel(_ modelName: String) {
        selectedModelName = modelName
        isPlacementMode = true
        showModelPicker = false
    }
    
    func placeModel(at position: SIMD3<Float>, with anchor: ARAnchor?) {
        let newModel = ARModel(
            name: selectedModelName,
            position: position,
            anchor: anchor
        )
        placedModels.append(newModel)
        totalModelsPlaced += 1
        isPlacementMode = false
    }
    
    func removeModel(_ model: ARModel) {
        if let index = placedModels.firstIndex(where: { $0.id == model.id }) {
            placedModels.remove(at: index)
        }
    }
    
    func removeAllModels() {
        placedModels.removeAll()
    }
    
    func toggleModelPicker() {
        showModelPicker.toggle()
    }
    
    func cancelPlacement() {
        isPlacementMode = false
    }
    
    func toggleStats() {
        showStats.toggle()
    }
    
    func getModelCount(for modelName: String) -> Int {
        return placedModels.filter { $0.name == modelName }.count
    }
    
    func resetStats() {
        totalModelsPlaced = 0
    }
}

struct ARModel: Identifiable {
    let id = UUID()
    let name: String
    let position: SIMD3<Float>
    let anchor: ARAnchor?
    var entity: Entity?
} 