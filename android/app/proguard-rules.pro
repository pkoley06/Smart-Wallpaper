# Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class plugins.flutter.io.**  { *; }

# OkHttp3 / Conscrypt workaround for missing classes during R8 minification
-dontwarn org.conscrypt.**
-dontwarn com.google.android.play.core.**
