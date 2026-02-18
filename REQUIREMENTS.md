# Product Hub Interview Requirements

Timebox: 1 hour 30 minutes total.

## Constraints

- Use the provided starter structure.
- You may choose any state management package.
- You may add helper packages if needed.
- Focus on correctness first, then polish.

## API Endpoints

- List products: `GET /products?limit={limit}&skip={skip}`
- Search products: `GET /products/search?q={query}`
- Categories: `GET /products/categories`
- Products by category: `GET /products/category/{category}`
- Product detail (optional direct fetch): `GET /products/{id}`

Base URL is configured in `lib/core/constants/app_constants.dart`.

## Phase 1 (30 minutes): Foundation

Goal: Display products from API with clear state handling.

Required:

1. Implement products remote data source.
2. Implement repository abstraction + implementation.
3. Configure chosen state management.
4. Build product list screen with:
   - loading state (use shimmer),
   - error state with retry,
   - success state with product cards.
5. Each card should show:
   - thumbnail,
   - title,
   - price + discount hint,
   - rating.

## Phase 2 (30 minutes): Features

Goal: Add navigation, filtering/search, and favorites.

Required:

1. Product detail screen:
   - image carousel/gallery,
   - title, brand, description, pricing, rating, stock.
2. Search with debounce:
   - search bar on list,
   - call search endpoint,
   - handle empty query.
3. Category filtering:
   - fetch categories,
   - filter by selected chip.
4. Favorites:
   - toggle favorite status,
   - persist favorite IDs using `shared_preferences`,
   - reflect favorite state in list/detail UI.

## Phase 3 (30 minutes): Advanced

Goal: Demonstrate scalability and code quality under pressure.

Required:

1. Infinite scrolling pagination in product list.
2. Pull-to-refresh.
3. Cart implementation:
   - add to cart from detail,
   - quantity updates,
   - remove item,
   - total price calculation,
   - cart count badge.

Bonus (if time remains):

- Unit test for data/repository layer.
- Widget test for a product card/list state.
- Offline caching strategy.r
- UX improvement (animation, dark mode, etc.).
