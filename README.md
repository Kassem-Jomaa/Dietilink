<img width="610" height="914" alt="Screenshot 2025-07-12 232807" src="https://github.com/user-attachments/assets/f4c67f28-8eaf-4640-a15e-5dd2acc2b28c" />
<img width="611" height="903" alt="Screenshot 2025-07-12 232849" src="https://github.com/user-attachments/assets/a7555258-fc5c-4b76-bb06-e439491c1d6d" />
<img width="592" height="747" alt="Screenshot 2025-07-12 234219" src="https://github.com/user-attachments/assets/2eac123f-6b42-4352-84cb-17f787e2fc7f" />
<img width="608" height="902" alt="Screenshot 2025-07-12 234544" src="https://github.com/user-attachments/assets/e80b806c-a450-458a-b449-b3ac4214cadd" />





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
