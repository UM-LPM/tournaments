plugins {
    application
}

dependencies {
    testImplementation(libs.junit.jupiter)

    testRuntimeOnly("org.junit.platform:junit-platform-launcher")

    implementation(libs.guava)
    implementation(files("ears.jar"))
}

val javaVersion = JavaLanguageVersion.of("21")

java {
    toolchain {
        languageVersion.set(javaVersion)
    }
}

application {
    mainClass = "org.example.App"
}

tasks.named<Test>("test") {
    useJUnitPlatform()
}

tasks.withType<AbstractArchiveTask>().configureEach {
    isPreserveFileTimestamps = false
    isReproducibleFileOrder = true
    dirPermissions { unix("755") }
    filePermissions { unix("644") }
}
