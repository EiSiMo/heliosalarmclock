# Ktor — keep CIO engine and routing
-keep class io.ktor.** { *; }
-keepclassmembers class io.ktor.** { *; }
-dontwarn io.ktor.**

# kotlinx.serialization — keep @Serializable classes
-keepattributes *Annotation*, InnerClasses
-dontnote kotlinx.serialization.AnnotationsKt
-keepclassmembers @kotlinx.serialization.Serializable class ** {
    *** Companion;
}
-keepclasseswithmembers class ** {
    kotlinx.serialization.KSerializer serializer(...);
}
-keep,includedescriptorclasses class com.example.helios_alarm_clock.**$$serializer { *; }
-keepclassmembers class com.example.helios_alarm_clock.** {
    *** Companion;
}
-keepclasseswithmembers class com.example.helios_alarm_clock.** {
    kotlinx.serialization.KSerializer serializer(...);
}

# Room — keep entities
-keep class com.example.helios_alarm_clock.data.AlarmEntity { *; }

# SLF4J (Ktor dependency) — suppress missing impl warnings
-dontwarn org.slf4j.**
