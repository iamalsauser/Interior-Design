//
//  PlacementModeView.swift
//  Interior_design
//
//  Created by Parth Sinh on 05/08/25.
//  Placement mode instructions and controls

import SwiftUI

struct PlacementModeView: View {
    @ObservedObject var viewModel: ARViewModel
    
    var body: some View {
        VStack {
            VStack(spacing: 8) {
                HStack {
                    Image(systemName: "hand.tap.fill")
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                    Text("Tap to place \(viewModel.selectedModelName)")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                }
                
                Text("Look for flat surfaces")
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(placementInstructionBackground)
            .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 2)
            .padding(.top, 60)
            
            Spacer()
            
            Button(action: {
                viewModel.cancelPlacement()
            }) {
                HStack {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 16))
                    Text("Cancel")
                        .font(.system(size: 16, weight: .medium))
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(Color.gray.opacity(0.8))
                .foregroundColor(.white)
                .cornerRadius(25)
                .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 1)
            }
            .padding(.bottom, 140)
        }
    }
    
    private var placementInstructionBackground: some View {
        Capsule()
            .fill(Color.blue.opacity(0.9))
            .overlay(
                Capsule()
                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
            )
    }
}
