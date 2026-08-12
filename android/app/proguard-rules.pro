# Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.**  { *; }

# Google Play Core split install suppressions
-dontwarn com.google.android.play.core.**
-dontwarn com.google.android.play.core.splitcompat.**
-dontwarn com.google.android.play.core.splitinstall.**
-dontwarn com.google.android.play.core.tasks.**

# WorkManager
-keep class androidx.work.** { *; }
-keep class com.dexterous.flutterlocalnotifications.** { *; }

# ONNX Runtime & JNI
-keep class ai.onnxruntime.** { *; }
-keep class com.google.ai.edge.** { *; }
-keepclassmembers class * {
    native <methods>;
}

# SQLite / Drift
-keep class com.memai.** { *; }
-keepattributes *Annotation*
-dontwarn javax.annotation.**
-dontwarn sun.misc.Unsafe
