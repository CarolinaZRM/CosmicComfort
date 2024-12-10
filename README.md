<!-- Start of new README content -->
# Getting Started

## Prerequisites:
- An Android (for Windows) or iOS (for MacOS) simulator, installation instructions best fit for your device can be found [here](https://docs.flutter.dev/get-started/install).
- Have Flutter SDK installed within a VSCode (or otherwise compatible) IDE instance, full step-by-step guide to install can be found [here](https://docs.flutter.dev/tools/vs-code) or on the embedded link of the previous prerequisite.

## Clone the repo via HTTPS
- If on VSCode, you can achieve this by opening the "Command Palette" by pressing Ctrl+Shift+P on your Keyboard or by clicking the "Gear" icon usually located on the bottom-left corner of the IDE interface and promptly selecting the "Command Palette..." option. Upon opening the Command palette, select the "Git: Clone" option then, when prompted to provide repository URL, paste the following URL: https://github.com/CarolinaZRM/CosmicComfort.git from here choose the "Clone from URL https://github.com/CarolinaZRM/CosmicComfort.git" option. Upon selecting this, you will be prompted to select the directory to which the repo will be clone to.

## Firebase Setup
- Head to the [Firebase](https://firebase.google.com/) website and login/signup with your account
- Click "Go to console" and start a new project by selecting the "Get started with a Firebase project" option.
- Name your project and create it.
- Go to the "Get started by adding Firebase to your app" area of the website and choose the iOS or Android options in accordance to your simulated device.
- When prompted to register the app, ensure that "com.example.cosmiccomfort" is the Android package name if the option selected was android, and the same is true for the App Bundle ID in the case for iOS devices.
- Upon registration of the app follow the following if:
  - On Android: Download the "google-services.json" file and place it on the CosmicComfort/android/app
  - On iOS: Download the "GoogleService-Info.plist" file and place it on the CosmicComfort/ios/Runner
## Running the app (On VSCode)
- Open the project directory within the cloned files by selecting the "File" -> "Open Folder..." options, the cloned directory name should be "CosmicComfort".
- Select the device simulator in which the app is going to be ran on from within vscode by selecting the device option within the VSCode IDE status bar, if no devices are currently connected this option may appear as "No Device". Selecting this will prompt the selection of the device. For more info on device selection visit the [official flutter documentation](https://docs.flutter.dev/tools/vs-code#:~:text=However%2C%20if%20you%20have%20multiple,use%20for%20running%20or%20debugging.) regarding device selection.
- Upon successful booting of the simulator, open a new terminal ("View" -> "Terminal" OR Ctrl + `) and run the following three commands within the terminal:
  - "flutter clean"
  - "flutter pub get"
  - "flutter run --release" OR "flutter run"
- Doing so will build and run the app within the simulated device

