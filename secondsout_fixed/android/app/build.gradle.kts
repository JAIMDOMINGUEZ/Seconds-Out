plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.secondsout_fixed"
    compileSdk = flutter.compileSdkVersion.toInt()
    ndkVersion = "27.0.12077973"  // Fixed: Using Kotlin assignment syntax

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.secondsout_fixed"
        minSdk = flutter.minSdkVersion?.toInt() ?: 21
        targetSdk = flutter.targetSdkVersion?.toInt() ?: 34
        versionCode = flutter.versionCode?.toInt() ?: 1
        versionName = flutter.versionName ?: "1.0"
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}