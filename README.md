# Senior Flutter Interview - Product Hub Starter

`Product Hub` is a progressive coding interview project for a 1 hour 30 minute
senior Flutter interview.

## Purpose

Evaluate full-stack Flutter capability through:
- API integration and data handling
- state management decisions
- architecture and code organization
- UI delivery and UX quality
- testing mindset

## Tech Stack Provided

- Flutter (Material 3)
- `dio` for HTTP
- `go_router` for navigation
- `cached_network_image` for images
- `shared_preferences` for local persistence
- `equatable` for value equality
- `shimmer` for loading placeholders

State management is intentionally not provided. Candidates choose and justify
their own approach.

## API

This project uses DummyJSON products API:
- Docs: https://dummyjson.com/docs/products
- Base URL: `https://dummyjson.com`

## Project Structure

```text
lib/
  core/
    api/
    constants/
    error/
    router/
    theme/
  features/
    products/
      data/
      domain/
      presentation/
    cart/
    favorites/
  main.dart
test/
```

## How To Run

1. Install Flutter SDK.
2. Run:
   - `flutter pub get`
   - `flutter run`

## Interview Flow (90 minutes)

- Phase 1 (0-30 min): foundation
- Phase 2 (30-60 min): feature depth
- Phase 3 (60-90 min): advanced features + testing/bonus

Detailed requirements are in `REQUIREMENTS.md`.
