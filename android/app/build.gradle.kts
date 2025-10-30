plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.appsly.games_all_in_one"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "29.0.13599879"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.appsly.games_all_in_one"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Create keystore and configure:
            // signingConfig = signingConfigs.getByName("release")
            signingConfig = signingConfigs.getByName("debug")
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }
    }

    // TODO: Uncomment and configure for production release:
    // signingConfigs {
    //     release {
    //         storeFile = file("../keystore.jks")
    //         storePassword = System.getenv("KEYSTORE_PASSWORD")
    //         keyAlias = System.getenv("KEY_ALIAS")
    //         keyPassword = System.getenv("KEY_PASSWORD")
    //     }
    // }
}

flutter {
    source = "../.."
}
