# Kobo

A personal budget manager for Nigerian university students. Kobo tells you how much is safe to spend today and this week so your money lasts until the next alert.

- Fully offline: no login, no account, no data costs
- All money in naira (₦), stored internally as whole kobo to avoid rounding errors
- Survival-first budgeting: essentials, then school, emergency buffer, savings, and finally wants

Built by G3Labs. Package name: `com.g3labs.kobo`.

## Status

- [x] Phase 1: Project setup, theme, database schema and models
- [x] Phase 2: Onboarding and budget setup
- [x] Design pass: banknote-inspired theme, typography and motion
- [ ] Phase 3: Expense/income logging and home dashboard
- [ ] Phase 4: History, weekly review and charts
- [ ] Phase 5: Warnings, notifications and savings goals
- [ ] Phase 6: Settings, app lock, export and backup
- [ ] Phase 7: Polish, testing and release build

## Tech stack

| Area | Choice |
| --- | --- |
| Framework | Flutter (Dart), Material 3 |
| State | Riverpod |
| Database | Drift (SQLite), works fully offline |
| Charts | fl_chart (Phase 4) |
| Notifications | flutter_local_notifications (Phase 5) |
| App lock | local_auth (Phase 6) |
| Formatting | intl |

## Requirements

- Flutter (latest stable) with the Android toolchain set up. Check with `flutter doctor`.
- An Android phone with USB debugging on, or an emulator.
- Minimum Android version: Android 6.0 (API 23).

## Run the app

```bash
git clone https://github.com/IzzySpace/Kobo.git
cd Kobo
flutter pub get
dart run build_runner build
flutter run
```

`build_runner` generates the database code (`lib/core/database/app_database.g.dart`). Run it again after changing any table in `lib/core/database/tables.dart`.

In debug builds, the temporary home screen has a **Reset all data** button that wipes the database and restarts onboarding.

## Run the tests

```bash
flutter test
```

Tests cover naira formatting and parsing, the database seed and constraints, the budget suggester (including zero balance, negative balance, a tight balance, and a cycle date that has already passed), and day counting.

## Build the APK

### Per-architecture APKs (smaller downloads)

```bash
flutter build apk --release --split-per-abi
```

Output in `build/app/outputs/flutter-apk/`:

| File | For |
| --- | --- |
| `app-arm64-v8a-release.apk` | Most phones from the last several years. Use this one if unsure. |
| `app-armeabi-v7a-release.apk` | Older and low-end 32-bit phones |
| `app-x86_64-release.apk` | Emulators and some Chromebooks |

### Universal APK (easiest to share)

```bash
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`. It works on any supported phone but is larger.

> Release signing is set up in Phase 7. Until then, release builds use the debug key, which is fine for testing but not for publishing.

## Install the APK on a phone

**Over USB:**

```bash
flutter install
```

or

```bash
adb install build/app/outputs/flutter-apk/app-arm64-v8a-release.apk
```

**By sharing the file:** send the APK over WhatsApp, Telegram, Google Drive or a cable. On the phone, open it and allow **Install unknown apps** for the app you opened it from when Android asks.

## Project structure

```
lib/
  main.dart                  App entry point
  app.dart                   Theme and routing (onboarding or home)
  core/
    database/                Drift tables, database class, default seed
    money/                   Kobo/naira formatting, parsing, validation
    theme/                   Colours, typography, theme extensions
    ui/                      Shared widgets: amount field, banknote card, motion
    dates.dart               Calendar-day helpers
    providers.dart           Riverpod providers
  features/
    onboarding/              Six-step setup flow
    budget/
      domain/                Budget suggester (pure Dart, unit tested)
      ui/                    Budget plan and category editor
    home/                    Home screen (dashboard in Phase 3)
test/                        Unit tests
assets/fonts/                Bricolage Grotesque
```

The database layer, business logic and UI are kept separate. Logic in `features/*/domain` has no Flutter imports, so it can be tested on its own.

## How the budget is suggested

Each category starts from a rough daily estimate (for example Food ₦2,000/day, Transport ₦800/day) multiplied by the days until your next income. Money is assigned in this order:

1. **Essentials**, scaled down to fit if your balance is short
2. **School**
3. **Emergency buffer**: 10% of your balance
4. **Savings**: 10% of your balance, only if you set a goal
5. **Wants**

Anything left over shows as "not yet assigned". Every amount can be changed. The daily estimates live in `lib/features/budget/domain/budget_suggester.dart`.

## Secrets

Never commit the release keystore (`*.jks`, `*.keystore`) or `key.properties`. Both are listed in `.gitignore`.

## Credits

Typeface: [Bricolage Grotesque](https://fonts.google.com/specimen/Bricolage+Grotesque), licensed under the SIL Open Font License 1.1.
