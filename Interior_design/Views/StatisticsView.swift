//
//  StatisticsView.swift
//  Interior_design
//
//  Created by Parth Sinh on 05/08/25.
//  Statistics dashboard and analytics components

import SwiftUI

struct StatisticsView: View {
    @ObservedObject var viewModel: ARViewModel
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 20) {
                Text("Placement Statistics")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                VStack(spacing: 15) {
                    StatisticRow(
                        icon: "cube.fill",
                        color: .blue,
                        title: "Total Items Placed:",
                        value: "\(viewModel.totalModelsPlaced)"
                    )
                    
                    StatisticRow(
                        icon: "chair.fill",
                        color: .orange,
                        title: "Chairs:",
                        value: "\(viewModel.getModelCount(for: "chair"))"
                    )
                    
                    StatisticRow(
                        icon: "table.furniture.fill",
                        color: .brown,
                        title: "Tables:",
                        value: "\(viewModel.getModelCount(for: "table"))"
                    )
                    
                    StatisticRow(
                        icon: "eye.fill",
                        color: .purple,
                        title: "Currently Visible:",
                        value: "\(viewModel.placedModels.count)"
                    )
                }
                .padding(.horizontal, 20)
                
                Button("Close") {
                    viewModel.showStats = false
                }
                .font(.system(size: 16, weight: .medium))
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(Color.gray.opacity(0.3))
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding(25)
            .background(statisticsBackground)
            .padding(.horizontal, 30)
            .padding(.bottom, 120)
        }
    }
    
    private var statisticsBackground: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color.black.opacity(0.85))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
            )
    }
}

struct StatisticRow: View {
    let icon: String
    let color: Color
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
            Text(title)
                .foregroundColor(.white)
            Spacer()
            Text(value)
                .fontWeight(.bold)
                .foregroundColor(.green)
        }
    }
}
