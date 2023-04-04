# iAdvize SDK Flutter Plugin integration

This repository goal is to demonstrate the integration process of the iAdvize Flutter SDK.
Each commit corresponds to an integration step and is described below.

## Prerequisites

```
$ flutter doctor

[✓] Flutter (Channel stable, 3.7.9, on macOS 13.2.1 22D68 darwin-arm64, locale en-FR)
[✓] Android toolchain - develop for Android devices (Android SDK version 33.0.2)
[✓] Xcode - develop for iOS and macOS (Xcode 14.2)
[✓] Chrome - develop for the web
[✓] Android Studio (version 2022.1)
[✓] IntelliJ IDEA Community Edition (version 2022.2.1)
[✓] VS Code (version 1.77.0)
[✓] Connected device (2 available)
[✓] HTTP Host Availability
```

## Steps

### Step 1 - Create Flutter project

To install the Flutter boilerplate code, run the following command:

```
flutter create integration_demo_app
```

This will create a `integration_demo_app` folder containing the Flutter project.
The Dart version used in this case is:

```
dart: ">=2.19.6 <3.0.0"
```

For the rest of this guide, the root folder for all commands will be the `integration_demo_app` repository so navigate to this folder:

```
cd integration_demo_app
```

To launch the app on a device run:

```
flutter run lib/main.dart
```

### Step 2 - Add the SDK Flutter plugin

To integrate the iAdvize SDK Flutter Plugin inside the demo project, run the following command:

```
flutter pub add iadvize_flutter_sdk
```

This will add the dependency inside the `pubspec.yaml` file

```
$ pubspec.yaml

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.2
  iadvize_flutter_sdk: ^2.10.1
```

### Step 3 - Configure iOS project

#### Step 3.1 - Define the minimum iOS platform

The iAdvize iOS SDK supports iOS 12 and further, you must define the minimum iOS platform at the top of your `ios/Podfile` file:

```
$ ios/Podfile

# Add this line
platform :ios, '12.0'
```

#### Step 3.2 - Enable Swift Library Evolution support

Add this step inside the `post_install` hook at the end of the `Podfile` to enable Swift Library Evolution:

```
$ ios/Podfile

post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)

    # Add those lines
    target.build_configurations.each do |config|
      config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
    end
  end
end
```

Library evolution support allows developers of binary frameworks to make additive changes to the API of their framework while remaining binary compatible with previous versions.

#### Step 3.3 - Download native iOS SDK pod

Once this is done, is it possible to download the iOS dependency pod:

```
cd ios
pod install
cd ..
```

#### Step 3.4 - Add microphone and camera permissions

Since the version 2.5.0, the iAdvize iOS SDK supports video conversations. Thus it will request camera and microphone access before entering a video call. To prevent the app from crashing at this stage, you have to setup two keys in your app `Info.plist`:

```
$ ios/Runner/Info.plist

<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    ...
    <key>NSCameraUsageDescription</key>
    <string>This application will use the camera to share photos and during video calls.</string>
    <key>NSMicrophoneUsageDescription</key>
    <string>This application will use the microphone during video calls.</string>
  </dict>
</plist>
```

### Step 4 - Configure Android project

#### Step 4.1 - Add Android SDK dependency repository

The iAdvize Android SDK is hosted on GitHub, this repository should be declared in the Android app in order for it to find the SDK artifacts:

```
$ android/build.gradle

allprojects {
  repositories {
    google()
    mavenCentral()

    // Add those lines
    maven { url "https://raw.github.com/iadvize/iadvize-android-sdk/master" }
    maven { url "https://jitpack.io" }
  }
}
```

#### Step 4.2 - Setup Kotlin

The latest iAdvize Android SDK used Kotlin `1.8.10`. To avoid conflict between the Kotlin versions used in the Flutter dependencies, this version needs to be set in the Android configuration.

In the project-level `android/build.gradle` file, update the Kotlin version in the `buildscript` block:

```
$ android/build.gradle

buildscript {
  // Update the Kotlin version
  ext.kotlin_version = '1.8.10' // was 1.7.10
}
```

#### Step 4.3 - Define the minimum Android platform

The iAdvize Android SDK supports Android API 21 and further, you must define the minimum supported API inside the `android/build.gradle` file:

```
$ android/build.gradle

android {
  defaultConfig {
    applicationId "com.example.integration_demo_app"
    minSdkVersion 21 // was minSdkVersion flutter.minSdkVersion
    targetSdkVersion 33 // was targetSdkVersion flutter.targetSdkVersion
    versionCode flutterVersionCode.toInteger()
    versionName flutterVersionName
  }
}
```

### Step 5 - Activate the SDK

Add the IAdvize SDK import statement:

```
$ lib/main.dart

import 'package:iadvize_flutter_sdk/iadvize_flutter_sdk.dart';
```

Then you can activate using the relevant API:

```
$ lib/main.dart

IAdvizeSdk.activate(
  projectId: projectId,
  authenticationOption: authOption,
  gdprOption: gdprOption,
)
```

### Step 6 - Trigger engagement

Once the SDK is activated you can engage the visitor using the relevant API:

```
$ lib/main.dart
IAdvizeSDK.setLanguage("targetingLanguage");
IAdvizeSdk.activateTargetingRule(
  TargetingRule(
    uuid: 'targetingRuleId',
    channel: ConversationChannel.chat,
  ),
);
```

This will display the Default Floating Button that leads to the Chatbox.

### Step X - Developer Platform

To go further in your integration you will need to read the SDK documentation available in our [Developer Platform](https://developers.iadvize.com/documentation/mobile-sdk#flutter-integration-guide).

This covers a wide range of the use cases you may have (chatbox configuration, custom button, notifications, transactions, custom data registration...)
