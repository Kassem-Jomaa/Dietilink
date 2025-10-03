// ...existing code...
# DietiLink (healthy)

A Flutter-based health & nutrition client app (DietiLink) — mobile + web — with modules for Profile, Meal Plans, Progress tracking, Appointments and an AI-powered Chatbot.

## Highlights
- Flutter app (mobile + web)
- GetX for state management, DI and routing
- Modular feature folders (auth, profile, meal_plan, progress, chatbot, appointments)
- The app bootstraps services and controllers at startup (see main.dart)

## Quick start

Prerequisites
- Flutter SDK (stable)
- A running backend (or mocked endpoints)
- Optional: Python chatbot server for full chatbot features

Install & run
```sh
cd healthy
flutter pub get
flutter run            # runs on connected device
flutter run -d chrome  # run web
```

Run tests
```sh
flutter test
```

## Configuration & environment
- API and runtime settings are provided by your backend config / environment variables. See `core/services/api_service.dart` for initialization details.
- Theme persistence is handled by `modules/settings/services/theme_service.dart`.

## How the app starts (main points)
- File: `lib/main.dart`
  - Ensures Flutter bindings: `WidgetsFlutterBinding.ensureInitialized()`
  - Initializes services: `ApiService().init()` (registered with Get)
  - Registers `ThemeService` and `AuthController` (AuthController is permanent)
  - Initializes theme via `_initializeTheme(...)`
  - Launches the app with `DietiLinkApp` which uses `GetMaterialApp`:
    - `theme`, `darkTheme`, `themeMode` (controlled by ThemeService)
    - Localization with `AppTranslations`
    - Routing via `AppPages.INITIAL` and `AppPages.routes`

## Project structure (important parts)
- lib/
  - core/                 — theme, services, utils (e.g., `app_theme.dart`, `api_service.dart`)
  - modules/              — feature modules (auth, settings, chatbot, meal_plan, progress, appointments)
  - routes/               — app route definitions (`app_pages.dart`)
  - translations.dart     — translation loader for GetX
  - main.dart             — app bootstrap (see above)

## Notes & tips
- Theme: The app sets `themeMode: ThemeMode.system` and ThemeService overwrites it on startup.
- Localization: Add translations in `translations.dart` and per-module keys.
- State & DI: Use GetX patterns already present (controllers/services registered via `Get.put` / `Get.putAsync`).

## Contributing
- Follow existing GetX patterns and code style.
- Add unit/widget tests for new features under `test/`.
- Update module-level README files when adding or changing features.

## License
Specify a license (e.g. MIT) or confirm project owner preference.

<!-- End of file -->