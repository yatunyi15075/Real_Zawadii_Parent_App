allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")

    // ✅ Set NDK version for all Android modules
    project.plugins.withId("com.android.application") {
        project.extensions.configure<com.android.build.gradle.BaseExtension>("android") {
            ndkVersion = "27.0.12077973"
        }
    }

    project.plugins.withId("com.android.library") {
        project.extensions.configure<com.android.build.gradle.BaseExtension>("android") {
            ndkVersion = "27.0.12077973"
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
