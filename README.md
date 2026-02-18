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

## Evaluation Rubric

| Area | Weight | What to Look For |
| --- | ---: | --- |
| Architecture | 25% | Clear separation of concerns, maintainable structure |
| State Management | 20% | Correctness, scalability, rationale for choice |
| API & Data | 20% | Robust loading/error handling, mapping, pagination |
| UI/UX | 20% | Usability, polish, responsiveness, meaningful states |
| Code Quality | 15% | Readability, naming, reuse, type safety, tests |

## Senior Signals

- Completes Phase 1 and most/all of Phase 2 with strong structure
- Handles unhappy paths (network fail, empty state, retries)
- Implements debounced search with proper state transitions
- Designs state to scale into cart/favorites/pagination
- Explains trade-offs clearly

## Red Flags

- No clear architecture
- No meaningful error handling
- Unstructured state or excessive ad-hoc `setState`
- Pagination or core data flows are broken
- Cannot justify design choices
