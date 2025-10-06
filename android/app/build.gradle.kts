import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Load local.properties
val localProperties = Properties().apply {
    val file = rootProject.file("local.properties")
    if (file.exists()) {
        file.inputStream().use { load(it) }
    }
}

val minSdkVersionInt = localProperties.getProperty("flutter.minSdkVersion")!!.toInt()
val targetSdkVersionInt = localProperties.getProperty("flutter.targetSdkVersion")!!.toInt()
val compileSdkVersionInt = localProperties.getProperty("flutter.compileSdkVersion")!!.toInt()
val appVersionCodeInt = (localProperties.getProperty("flutter.versionCode") ?: "100").toInt()
val appVersionName = localProperties.getProperty("flutter.versionName") ?: "1.0.0"


android {
    namespace = "com.example.finance_tracker"
    compileSdk = compileSdkVersionInt
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.finance_tracker"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = minSdkVersionInt
        targetSdk = targetSdkVersionInt
        versionCode = appVersionCodeInt
        versionName = appVersionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
