//
//  ModelPickerView.swift
//  Interior_design
//
//  Created by Parth Sinh on 05/08/25.
//  Model picker and furniture selection components

import SwiftUI

struct ModelPickerView: View {
    @ObservedObject var viewModel: ARViewModel
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 20) {
                Text("Select Furniture")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                ForEach(viewModel.availableModels, id: \.self) { model in
                    FurnitureItemView(model: model, viewModel: viewModel)
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
            .background(modelPickerBackground)
            .padding(.horizontal, 30)
            .padding(.bottom, 120)
        }
    }
    
    private var modelPickerBackground: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color.black.opacity(0.85))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
            )
    }
}

struct FurnitureItemView: View {
    let model: String
    @ObservedObject var viewModel: ARViewModel
    
    var body: some View {
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
            .background(furnitureItemBackground)
            .foregroundColor(.white)
        }
    }
    
    private var furnitureItemBackground: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.white.opacity(0.15))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
            )
    }
}
