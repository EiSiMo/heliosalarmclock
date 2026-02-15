# Helios Alarm Clock

An Android alarm clock with an embedded HTTP server for remote control from a Raspberry Pi or any device on the local network.

## Features

- **HTTP API** on port 8080 for remote alarm management
- **Material 3 UI** with time picker and alarm list
- **Reliable alarms** via `AlarmManager.setExactAndAllowWhileIdle()` (survives Doze)
- **Full-screen alarm** with system alarm sound and DND bypass
- **Persistent server** as a foreground service with wake lock
- **Boot survival** — server and alarms reschedule after reboot
- **Auto-cleanup** — fired alarms are deleted automatically

## HTTP API

All endpoints listen on port `8080`. Replace `PHONE_IP` with the IP shown in the app.

### Set an alarm

```bash
curl -X POST http://PHONE_IP:8080/set \
  -H "Content-Type: application/json" \
  -d '{"hour": 7, "minute": 30, "label": "Wake up"}'
```

Response: `201 Created`
```json
{"id": "550e8400-e29b-41d4-a716-446655440000"}
```

`hour` must be 0-23, `minute` must be 0-59. `label` is optional (defaults to empty).

### Remove an alarm

```bash
curl -X POST http://PHONE_IP:8080/rm \
  -H "Content-Type: application/json" \
  -d '{"id": "550e8400-e29b-41d4-a716-446655440000"}'
```

### List alarms

```bash
curl http://PHONE_IP:8080/list
```

Returns a JSON array of all scheduled alarms.

## Security

The HTTP server has **no authentication**. Anyone on the same network can set or remove alarms. Only run this on a trusted local network.

## Tech Stack

- Kotlin, Jetpack Compose, Material 3
- MVVM with Hilt dependency injection
- Room database for persistence
- Ktor CIO embedded HTTP server
- Foreground service (`connectedDevice` type)

## Requirements

- Android 8.0+ (API 26)
- Target SDK 36 (Android 16)

## Permissions

| Permission | Purpose |
|---|---|
| `INTERNET` / `ACCESS_NETWORK_STATE` | HTTP server |
| `FOREGROUND_SERVICE_CONNECTED_DEVICE` | Keep server alive |
| `SCHEDULE_EXACT_ALARM` / `USE_EXACT_ALARM` | Precise alarm timing |
| `USE_FULL_SCREEN_INTENT` | Wake screen on alarm |
| `WAKE_LOCK` | Prevent CPU sleep |
| `RECEIVE_BOOT_COMPLETED` | Restart after reboot |
| `POST_NOTIFICATIONS` | Service + alarm notifications |

## Building

```bash
./gradlew assembleRelease
```

The APK is at `app/build/outputs/apk/release/app-release.apk`.

## Installing via ADB

```bash
adb install app/build/outputs/apk/release/app-release.apk
```

## Troubleshooting

- **Server not reachable**: Ensure the phone and client are on the same Wi-Fi network. Check that battery optimization is disabled for the app.
- **Alarm doesn't fire**: Grant exact alarm permission in system settings. Disable battery optimization for the app.
- **Notification not showing**: Grant notification permission (Android 13+).
- **Server dies in background**: Some OEMs aggressively kill background services. Disable battery optimization and lock the app in recents.

## License

MIT
