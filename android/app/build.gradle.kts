plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

android {
    namespace = "com.bloodbridge.fci"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        // ✅ مهم جدًا لحل المشكلة
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        // ✅ خليها متوافقة مع Java 8
        jvmTarget = "1.8"
    }

    defaultConfig {
        applicationId = "com.bloodbridge.fci"
        minSdk = flutter.minSdkVersion   // تأكد إنها 21 أو أعلى
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

dependencies {
    // ✅ حل مشكلة flutter_local_notifications
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")

    // Firebase BoM
    implementation(platform("com.google.firebase:firebase-bom:34.8.0"))

    // Firebase Analytics
    implementation("com.google.firebase:firebase-analytics")
}

flutter {
    source = "../.."
}
