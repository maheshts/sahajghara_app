// ✅ REQUIRED IMPORTS (fixes your error)
import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.app.sahajghara"
    compileSdk = flutter.compileSdkVersion

    // ✅ safer to use Flutter default
    ndkVersion = flutter.ndkVersion

    // ✅ Load keystore properties
    val keystorePropertiesFile = rootProject.file("key.properties")
    val keystoreProperties = Properties()

    if (keystorePropertiesFile.exists()) {
        keystoreProperties.load(FileInputStream(keystorePropertiesFile))
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        // ⚠️ Warning only (safe to keep for now)
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    // ✅ Signing config (safe)
    signingConfigs {
        create("release") {
            if (keystorePropertiesFile.exists()) {
                keyAlias = keystoreProperties["keyAlias"]?.toString()
                keyPassword = keystoreProperties["keyPassword"]?.toString()

                val storeFilePath = keystoreProperties["storeFile"]?.toString()
                if (storeFilePath != null) {
                    storeFile = file(storeFilePath)
                }

                storePassword = keystoreProperties["storePassword"]?.toString()
            }
        }
    }

    defaultConfig {
        applicationId = "com.app.sahajghara"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {

        getByName("debug") {
            signingConfig = signingConfigs.getByName("debug")
        }

        getByName("release") {

            signingConfig = if (keystorePropertiesFile.exists()) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }

            // ✅ keep disabled for now (enable later)
            isMinifyEnabled = false
            isShrinkResources = false

            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

flutter {
    source = "../.."
}