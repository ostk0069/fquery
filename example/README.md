# fquery Example App

This example demonstrates how to use the fquery package for asynchronous state management in Flutter applications.

## Getting Started

This example app showcases various features of fquery including:
- Basic queries with `useQuery`
- Mutations with `useMutation`
- Infinite queries with `useInfiniteQuery`
- Query composition with `createQuery`
- Select transformations
- Cache management

## Using createQuery in fquery

The `createQuery` function allows you to bundle query key and fetcher into a single reusable object.

### Basic Usage

```dart
// Define your query configuration
final postsQuery = createQuery(
  ['posts'],
  () async {
    final response = await dio.get('/api/posts');
    return (response.data as List).map((e) => Post.fromJson(e)).toList();
  },
);

// Use it in your widget with useQuery
class PostsWidget extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final result = useQuery<List<Post>, dynamic>(
      postsQuery,
      staleDuration: const Duration(minutes: 5),
    );
    
    if (result.isLoading) return CircularProgressIndicator();
    if (result.isError) return Text('Error: ${result.error}');
    
    return ListView.builder(
      itemCount: result.data!.length,
      itemBuilder: (context, index) => Text(result.data![index].title),
    );
  }
}
```

### With Select Transformation

```dart
// Define base query
final todosQuery = createQuery(
  ['todos'],
  fetchTodos,
);

// Use with select transformation
final completedTodos = useQueryWithSelect<List<Todo>, dynamic, List<Todo>>(
  todosQuery.queryKey,
  todosQuery.fetcher,
  select: (todos) => todos.where((todo) => todo.completed).toList(),
);

// Count query
final todosCount = useQueryWithSelect<List<Todo>, dynamic, int>(
  todosQuery.queryKey,
  todosQuery.fetcher,
  select: (todos) => todos.length,
);
```

### Dynamic Queries

```dart
// Create a factory function for dynamic queries
QueryConfig<Todo> createTodoByIdQuery(int id) {
  return createQuery(
    ['todo', id],
    () async {
      final response = await dio.get('/api/todos/$id');
      return Todo.fromJson(response.data);
    },
  );
}

// Use it in your widget
class TodoDetailWidget extends HookWidget {
  final int todoId;
  
  const TodoDetailWidget({required this.todoId});
  
  @override
  Widget build(BuildContext context) {
    final todoQuery = createTodoByIdQuery(todoId);
    final result = useQuery<Todo, dynamic>(todoQuery);
    
    // ... render UI
  }
}
```

## Benefits of createQuery

1. **Reusability**: Define once, use anywhere
2. **Type Safety**: Full TypeScript-style generics support
3. **Organization**: Keep query logic separate from UI
4. **Testability**: Easy to test query configurations in isolation
5. **Consistency**: Ensure the same query configuration across your app

## Usage Patterns

### Pattern 1: Using createQuery with useQuery
```dart
// Create configuration
final query = createQuery(['key'], fetcher);

// Use with options (positional parameters)
final result = useQuery<TData, TError>(
  query,
  true, // enabled
  RefetchOnMount.stale, // refetchOnMount (optional)
  Duration(minutes: 5), // staleDuration (optional)
  Duration(hours: 1), // cacheDuration (optional)
  null, // refetchInterval (optional)
  3, // retryCount (optional)
  Duration(seconds: 1), // retryDelay (optional)
);
```

### Pattern 2: Traditional useQuery
```dart
// Still works as before
final result = useQuery<TData, TError>(
  ['key'],
  fetcher,
  true, // enabled
  null, // refetchOnMount
  Duration(minutes: 5), // staleDuration
);
```

## Running the Example

1. Navigate to the example directory:
   ```bash
   cd example
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the example app:
   ```bash
   flutter run
   ```

## Learn More

For more information about fquery, see the [main package documentation](https://pub.dev/packages/fquery).
