# Implementation Plan - Mobile Auth Flow & Splash Screen

This plan covers making the authentication flow responsive for mobile devices and adding a splash screen for initial app loading.

## User Review Required

> [!NOTE]
> The splash screen will use the existing `login_avatar.png` as a placeholder for the logo. If there is a specific brand logo, please provide its path.

## Proposed Changes

### [Component Name] - Auth Flow (Responsive Design)

Modify the `AuthLayout` to adapt to mobile screens. On smaller screens, the illustration will be hidden or moved to avoid cramping the form.

#### [MODIFY] [auth_layout.dart](file:///C:/Users/noteb/StudioProjects/service_request/lib/features/auth/presentation/widgets/auth_layout.dart)
- Update code to use `LayoutBuilder` or `MediaQuery` to detect screen width.
- Switch from `Row` to `Column` or hide the illustration on mobile.

#### [MODIFY] [login_page.dart](file:///C:/Users/noteb/StudioProjects/service_request/lib/features/auth/presentation/pages/login_page.dart)
- Ensure horizontal padding in `AuthLayout` is not too large for mobile.

---

### [Component Name] - Splash Screen

#### [NEW] [splash_screen.dart](file:///C:/Users/noteb/StudioProjects/service_request/lib/features/auth/presentation/pages/splash_screen.dart)
- Create a simple splash screen with a logo and loading indicator.
- Handle redirection logic or wait for `GoRouter`'s redirect.

#### [MODIFY] [route_names.dart](file:///C:/Users/noteb/StudioProjects/service_request/lib/core/router/route_names.dart)
- Add `static const String splash = '/';`.
- Rename `login` to `/login` if it was the root before (it was already `/login`).

#### [MODIFY] [app_router.dart](file:///C:/Users/noteb/StudioProjects/service_request/lib/core/router/app_router.dart)
- Add the splash screen route.
- Set `initialLocation` to `RouteNames.splash`.

## Verification Plan

### Automated Tests
- N/A (UI focused)

### Manual Verification
- Run the app on a mobile emulator/device.
- Verify the splash screen appears first.
- Verify the login page layout is appropriate for mobile (no side-by-side illustration).
- Verify the OTP and Profile Setup pages are also readable on mobile.
