# Interior Design AR App

A SwiftUI macOS/iOS app that uses ARKit and RealityKit to scan rooms and place 3D furniture models on detected surfaces.

## Features

- **Room Scanning**: Uses ARKit to detect floors and walls
- **Furniture Placement**: Tap to place 3D models on detected surfaces
- **Model Selection**: Choose from available furniture models
- **Light Estimation**: Real-world lighting for realistic placement
- **Occlusion Support**: Models are occluded by real objects when supported
- **MVVM Architecture**: Uses Combine for reactive state management
- **SwiftUI Integration**: ARView wrapped for SwiftUI compatibility

## Project Structure

```
Interior_design/
├── ARViewModel.swift          # MVVM view model with Combine
├── ARViewContainer.swift      # ARKit wrapper for SwiftUI
├── ContentView.swift          # Main UI with controls
├── chair.usdz                # Sample chair model (placeholder)
├── table.usdz                # Sample table model (placeholder)
└── Interior_design.entitlements  # App permissions
```

## Setup Instructions

1. **Add USDZ Models**: Replace placeholder files with actual USDZ models
   - `chair.usdz` - Chair furniture model
   - `table.usdz` - Table furniture model

2. **Build and Run**: Open in Xcode and run on iOS device or simulator

3. **Permissions**: Camera access is required for AR functionality

## Usage

1. **Scan Room**: Point camera at room to detect surfaces
2. **Select Model**: Tap model selection button to choose furniture
3. **Place Furniture**: Tap on detected surface to place selected model
4. **Remove Models**: Use "Clear All" button to remove all placed models

## Technical Details

- **ARKit**: World tracking with plane detection
- **RealityKit**: 3D model rendering and scene management
- **SwiftUI**: Modern declarative UI framework
- **Combine**: Reactive programming for state management
- **MVVM**: Clean architecture pattern

## Requirements

- iOS 14.0+ / macOS 11.0+
- Xcode 12.0+
- Device with ARKit support (iPhone 6s+ or iPad Pro)

## Notes

- USDZ models must be added to the app bundle
- Camera permissions are required
- AR functionality requires a physical device (not simulator) 