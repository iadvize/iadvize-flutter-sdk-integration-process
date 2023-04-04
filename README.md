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

Library evolution support allows developers of binary frameworks to make additive changes to the API of their framework while remaining binary compatible with previous versions.
