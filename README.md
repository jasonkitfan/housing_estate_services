# housing_estate_services
A Flutter project to integrate all systems and services in a large housing estate
#

Settings:
# deploying SDK version
dart: 2.18.2
flutter: 3.3.4

# ios/Podfile
IOS version: 12 or above

# android/app/build.gradle
minSdkVersion: 21 or above
compileSdkVersion: 33

# android/build.gradle
Kotlin version: 1.5.0 or above

# android/app/src/main/java/com/example/housing_estate_services/MainActivity.java
Using FlutterFragmentActivity instead of FlutterActivity in MainActivity.kt

# request permission on camera, microphone, photo gallery and storage
## ios  ##  ios/Runner/info.plist
<key>NSCameraUsageDescription</key>
<string>Explanation on why the camera access is needed.</string>
<key>NSMicrophoneUsageDescription</key>
<string>Explanation on why the microphone access is needed.</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>Explanation on why the camera access is needed.</string>
## android  ##  app/src/main/AndroidManifest.xml
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
###
