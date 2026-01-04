# Guitar Tuner iOS 🎸

![Swift](https://img.shields.io/badge/Swift-5.0+-orange.svg) ![iOS](https://img.shields.io/badge/iOS-16.0+-blue.svg) ![AudioKit](https://img.shields.io/badge/AudioKit-5.6-yellow.svg) ![Beta](https://img.shields.io/badge/Status-Beta-red.svg)

A modern, fast, and accurate guitar tuner application for iOS, built with SwiftUI and powered by AudioKit.

> [!WARNING]  
> **Beta Version 0.0.1**  
> This application is currently in early beta. You may encounter bugs, UI glitches, or incomplete features as we continue to refine the tuning engine and user experience. Feedback is welcome!

## Features ✨

*   **Precise Audio Analysis**: Utilizes [AudioKit's](https://audiokit.io/) advanced audio analysis tools (PitchTap) for accurate real-time pitch detection.
*   **Visual Tuning**: Intuitive user interface with a visual tuning bar to help you achieve the perfect pitch.
*   **Modern Design**: Built entirely with **SwiftUI** for a smooth, responsive, and accessible user experience.
*   **String & Note Support**: Select specific strings for targeted tuning or use the chromatic mode.

## Technology Stack 🛠️

*   **Language**: Swift
*   **UI Framework**: SwiftUI
*   **Audio Engine**: AudioKit (including `AudioKitEX` & `SoundpipeAudioKit`)
*   **Project Management**: [XcodeGen](https://github.com/yonaskolb/XcodeGen) - used to generate the `.xcodeproj` file from the `project.yml` specification.

## Getting Started 🚀

### Prerequisites

*   Xcode 14.0+
*   iOS 16.0+
*   [XcodeGen](https://github.com/yonaskolb/XcodeGen) (optional, but recommended if you want to regenerate the project)

### Installation

1.  **Clone the repository**:
    ```bash
    git clone https://github.com/erichsilveira/guitar-tuner-ios.git
    cd guitar-tuner-ios
    ```

2.  **Generate the Project**:
    This project uses `XcodeGen` to manage the Xcode project file. Run the following command in the root directory:
    ```bash
    xcodegen generate
    ```

3.  **Open and Run**:
    Open the generated `GuitarTuner.xcodeproj` file in Xcode and run it on your simulator or physical device.

    > **Note**: For the microphone to work properly, testing on a physical device is recommended.

## Recent Updates 📝

*   **UI Overhaul**: Complete redesign of the interface for better usability and aesthetics.
*   **Core Refactor**: Migrated the audio processing engine to use AudioKit's `PitchTap` for improved accuracy and stability.
*   **String Selection**: Added functionality to select specific strings for tuning.

---

*Developed with ❤️ by Erich Pinton*
