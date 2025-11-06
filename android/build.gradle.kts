// Top-level build.gradle.kts

// 🔹 Buildscript for classpath dependencies
buildscript {
    repositories {
        google()      // Google's Maven repository
        mavenCentral() // Maven Central repository
    }
    dependencies {
        // Android Gradle Plugin
        classpath("com.android.tools.build:gradle:8.1.0")

        // Google Services plugin for Firebase
        classpath("com.google.gms:google-services:4.4.4")
    }
}

// 🔹 Plugins block (apply false here so app module can apply it later)
plugins {
    id("com.google.gms.google-services") apply false
}

// 🔹 Repositories for all projects
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// 🔹 Change the build directory to a custom location
val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build") // "../../build" is relative to the root
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

// 🔹 Set up each subproject to have its own build directory
subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

// 🔹 Make sure the app module is evaluated before others
subprojects {
    project.evaluationDependsOn(":app")
}

// 🔹 Clean task
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
