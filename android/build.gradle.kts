// Top-level Gradle build configuration file
// Aman untuk Flutter 3.24+ dan Gradle Plugin 8.9+

import org.gradle.api.tasks.Delete
import org.gradle.api.file.Directory

plugins {
    // Jangan pakai versi manual — biar Flutter tentukan otomatis
    id("com.android.application") apply false
    id("org.jetbrains.kotlin.android") apply false
    id("dev.flutter.flutter-gradle-plugin") apply false
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// 🔧 (Opsional) Ubah lokasi hasil build ke folder di luar android/
val newBuildDir: Directory = rootProject.layout.buildDirectory
    .dir("../../build")
    .get()
rootProject.layout.buildDirectory.set(newBuildDir)

subprojects {
    // Atur agar setiap subproject build di folder yang sama
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.set(newSubprojectBuildDir)
}

// 🧩 Pastikan semua subproject depend pada app
subprojects {
    project.evaluationDependsOn(":app")
}

// 🧹 Task untuk membersihkan hasil build
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

