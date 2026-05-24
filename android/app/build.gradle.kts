plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")

    // FIREBASE
    id("com.google.gms.google-services")
}

android {

    namespace = "com.example.e_deslay.e_deslay"

    compileSdk = 36

    ndkVersion = flutter.ndkVersion

    compileOptions {

        sourceCompatibility =
            JavaVersion.VERSION_17

        targetCompatibility =
            JavaVersion.VERSION_17

        // ================= DESUGARING =================
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {

        jvmTarget =
            JavaVersion.VERSION_17.toString()
    }

    defaultConfig {

        applicationId =
            "com.example.e_deslay.e_deslay"

        minSdk = flutter.minSdkVersion

        targetSdk = 36

        versionCode =
            flutter.versionCode

        versionName =
            flutter.versionName
    }

    buildTypes {

        release {

            signingConfig =
                signingConfigs.getByName(
                    "debug"
                )
        }
    }
}

dependencies {

    // ================= DESUGARING =================
    coreLibraryDesugaring(
        "com.android.tools:desugar_jdk_libs:2.1.4"
    )
}

flutter {
    source = "../.."
}
