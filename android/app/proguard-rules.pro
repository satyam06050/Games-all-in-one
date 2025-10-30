# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Play Core library - ignore missing classes
-dontwarn com.google.android.play.core.**
-ignorewarnings
-keep class com.google.android.play.core.** { *; }

# GetX
-keep class com.google.gson.** { *; }
-keepclassmembers class * extends com.google.gson.** { *; }

# Preserve annotations
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes Exceptions
