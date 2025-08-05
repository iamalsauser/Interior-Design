# Interior Design AR Application

**Developer:** Parth Sinh  
**GitHub:** https://github.com/iamalsauser  
**LinkedIn:** https://www.linkedin.com/in/parth-sinh-045b8324b/

An iOS AR application built with SwiftUI, ARKit, and RealityKit that allows users to scan rooms and place virtual furniture with realistic lighting and physics.

## Project Overview

This project was developed as **Challenge 4: ARKit - Interior Design AR Application** to help users redesign their living spaces by scanning rooms and placing 3D furniture models with accurate scaling, realistic shadows, and proper occlusion handling.

## Features

### Room Scanning and Detection
- **Scene Reconstruction**: Uses ARKit's world tracking for room mapping
- **Surface Detection**: Automatically detects walls, floors, and ceilings
- **Visual Feedback**: Real-time scanning indicators and surface highlighting

### 3D Furniture Placement
- **USDZ Model Loading**: Loads 3D models from app bundle (chair.usdz, table.usdz)
- **Snap-to-Surface**: Furniture automatically aligns to detected floors and walls
- **Tap-to-Place**: Simple tap gesture for intuitive furniture placement
- **Model Selection**: Choose from available furniture catalog

### Realistic Rendering
- **Light Estimation**: ARKit's lighting estimation for realistic shadows
- **Occlusion Handling**: Virtual objects are occluded by real-world objects
- **Environment Texturing**: Automatic environment mapping for realistic reflections

### User Interface
- **Minimal Overlay**: Clean, non-intrusive UI controls
- **Model Picker**: Simple dropdown for furniture selection
- **Placement Mode**: Visual indicators during furniture placement
- **Remove Functionality**: Clear all placed models with one tap

## Technical Implementation

### Architecture
- **MVVM Pattern**: Clean separation of concerns
- **Combine Framework**: Reactive data binding with @Published properties
- **SwiftUI**: Modern declarative UI framework
- **ARKit + RealityKit**: Advanced AR capabilities

### Key Components
- `ARViewModel`: Manages app state and furniture placement logic
- `ARViewContainer`: SwiftUI wrapper for ARKit's ARView
- `ContentView`: Main UI with overlay controls
- `ARModel`: Data structure for placed furniture

### AR Configuration
```swift
let configuration = ARWorldTrackingConfiguration()
configuration.planeDetection = [.horizontal, .vertical]
configuration.environmentTexturing = .automatic
configuration.isLightEstimationEnabled = true
```

## Setup Instructions

### Prerequisites
- iOS 14.0+ / macOS 11.0+
- Xcode 12.0+
- Physical iOS device with ARKit support (iPhone 6s+ or iPad Pro)

### Installation
1. Clone the repository
2. Open `Interior_design.xcodeproj` in Xcode
3. Build and run on a physical device
4. Grant camera permissions when prompted

### Usage
1. **Scan Room**: Point camera at room to detect surfaces
2. **Select Furniture**: Tap model selection button
3. **Place Models**: Tap on detected surfaces to place furniture
4. **Remove Models**: Use "Clear All" button to reset

## Project Structure

```
Interior_design/
├── ARViewModel.swift          # MVVM view model with Combine
├── ARViewContainer.swift      # ARKit wrapper for SwiftUI
├── ContentView.swift          # Main UI with controls
├── Interior_designApp.swift   # App entry point
├── Interior_design.entitlements  # Camera permissions
├── chair.usdz                # 3D chair model (42MB)
├── table.usdz                # 3D table model (30MB)
└── Assets.xcassets/          # App assets
```

## Technical Challenges Solved

### Surface Detection
- Implemented raycast-based surface detection
- Automatic alignment to detected planes
- Visual feedback for scanning progress

### Model Placement
- USDZ model loading from app bundle
- Transform-based positioning with anchors
- Collision shape generation for physics

### Lighting Integration
- Real-world lighting estimation
- Dynamic shadow casting
- Environment-based reflections

### Performance Optimization
- Efficient model loading and caching
- Proper memory management
- Session state handling

## Requirements Met

✅ **Room Scanning**: ARKit scene reconstruction with visual feedback  
✅ **Surface Detection**: Walls, floors, and ceilings detection  
✅ **3D Model Loading**: USDZ format with snap-to-surface  
✅ **Realistic Rendering**: Lighting estimation and occlusion  
✅ **MVVM + Combine**: Clean architecture with reactive data  
✅ **Gesture Support**: Tap-to-place functionality  
✅ **Visual Feedback**: Scanning indicators and placement guides  

## Limitations

- Requires physical iOS device (ARKit doesn't work in simulator)
- Camera permissions required
- Limited to devices with ARKit support
- USDZ models must be included in app bundle

## Future Enhancements

- Multiple furniture categories
- Custom furniture scaling
- Furniture rotation controls
- Room measurement features
- Furniture catalog expansion
- Save/load room configurations

## Development Notes

This project demonstrates advanced iOS AR development using Apple's latest frameworks. The implementation focuses on user experience with minimal UI and maximum AR immersion. The MVVM architecture ensures maintainable code while Combine provides reactive state management.

## Important Notes

- USDZ models must be added to the app bundle
- Camera permissions are required
- AR functionality requires a physical device (not simulator)

Built with ❤️ using SwiftUI, ARKit, and RealityKit.
