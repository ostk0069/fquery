# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

fquery is a Flutter package for asynchronous state management, similar to React Query/TanStack Query. It provides hooks for data fetching, caching, and synchronization in Flutter applications.

## Development Commands

### Package Development
```bash
# Install dependencies
flutter pub get

# Run code generation (for freezed models)
flutter pub run build_runner build --delete-conflicting-outputs

# Run linter
flutter analyze

# Run tests
flutter test

# Format code
dart format .
```

### Example App Development
```bash
# Navigate to example directory
cd example

# Install dependencies
flutter pub get

# Run the example app
flutter run

# Run tests
flutter test
```

## Architecture

### Core Components

1. **QueryClient** (`lib/src/query_client.dart`) - Central manager for all queries and mutations
   - Manages the QueryCache
   - Provides global configuration via DefaultQueryOptions
   - Methods for invalidating queries and setting query data

2. **Query** (`lib/src/query.dart`) - Represents a single cached query
   - Manages fetch lifecycle (loading, success, error states)
   - Handles automatic refetching and retry logic
   - Implements stale-while-revalidate pattern

3. **Observer Pattern** - Used throughout for reactive updates
   - QueryObserver watches Query instances
   - MutationObserver watches Mutation instances
   - Notifies hooks/widgets when data changes

4. **Hooks** (in `lib/src/hooks/`) - Flutter Hooks integration
   - `useQuery` - Primary hook for data fetching
   - `useMutation` - For data mutations
   - `useInfiniteQuery` - For paginated data
   - `useQueries` - For dynamic parallel queries
   - `useQueryClient` - Access QueryClient instance

5. **Widgets** (in `lib/src/widgets/`) - Alternative to hooks
   - `QueryBuilder` - Query without hooks
   - `MutationBuilder` - Mutations without hooks
   - `InfiniteQueryBuilder` - Infinite queries without hooks
   - `QueryClientProvider` - Provides QueryClient to widget tree

### Key Patterns

1. **Query Keys** - Arrays that uniquely identify queries in the cache
   - Hierarchical structure allows partial invalidation
   - Deep equality comparison for matching

2. **Stale-While-Revalidate** - Core caching strategy
   - Returns stale data immediately while fetching fresh data
   - Configurable stale duration per query

3. **Automatic Garbage Collection** - Unused queries are removed from cache
   - Configurable cache duration
   - Prevents memory leaks

4. **Optimistic Updates** - For mutations
   - Update cache immediately before server confirmation
   - Rollback on error

### State Management

The package uses Freezed for immutable state models. The main state model is in `lib/src/query_state.dart` and `query_state.freezed.dart`.

## Testing Approach

Tests should focus on:
- Query lifecycle (loading, success, error states)
- Cache behavior and invalidation
- Retry logic
- Hook behavior and re-renders
- Widget builders

The package currently has minimal test coverage. When adding features, include corresponding tests.

## Code Style

- Follows standard Dart/Flutter conventions
- Uses `package:lints/recommended.yaml` for analysis
- Prefer named parameters for configuration objects
- Use Freezed for complex state objects
- Document public APIs with dartdoc comments

## Important Notes

- The package depends on `flutter_hooks` for hook functionality
- All async operations should be properly cancelled on disposal
- Query keys use deep equality comparison (via collection package)
- The example app demonstrates all major features