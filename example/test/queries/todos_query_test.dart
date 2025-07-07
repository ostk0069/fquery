import 'package:basic/models/todos.dart';
import 'package:basic/queries/todos_query.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fquery/fquery.dart';

void main() {
  late QueryClient queryClient;

  setUp(() {
    queryClient = QueryClient();
  });

  tearDown(() {
    // QueryClient doesn't have dispose method
  });

  group('todosQuery', () {
    test('should create a query configuration with correct key', () {
      final query = todosQuery;
      expect(query.queryKey, equals(['todos']));
    });

    testWidgets('should fetch todos successfully', (tester) async {
      await tester.pumpWidget(
        QueryClientProvider(
          queryClient: queryClient,
          child: MaterialApp(
            home: HookBuilder(
              builder: (context) {
                final result = useQuery(todosQuery);
                
                if (result.isLoading) {
                  return const CircularProgressIndicator();
                }
                
                if (result.error != null) {
                  return Text('Error: ${result.error}');
                }
                
                return Column(
                  children: [
                    Text('Todo count: ${result.data!.length}'),
                    if (result.data!.isNotEmpty) Text(result.data!.first.text),
                  ],
                );
              },
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      
      // Wait for the 3-second delay in MockServer
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();
      
      // Verify todos are displayed
      expect(find.text('Todo count: 10'), findsOneWidget);
      expect(find.text('Finish homework'), findsOneWidget);
    });

    testWidgets('should respect enabled option', (tester) async {
      await tester.pumpWidget(
        QueryClientProvider(
          queryClient: queryClient,
          child: MaterialApp(
            home: HookBuilder(
              builder: (context) {
                final result = useQuery(
                  todosQuery,
                  enabled: false,
                );
                
                return Column(
                  children: [
                    Text('Is Loading: ${result.isLoading}'),
                    Text('Has Data: ${result.data != null}'),
                  ],
                );
              },
            ),
          ),
        ),
      );

      await tester.pump();
      
      expect(find.text('Is Loading: false'), findsOneWidget);
      expect(find.text('Has Data: false'), findsOneWidget);
    });

    testWidgets('should handle refetch', (tester) async {
      late Future<void> Function() refetchFn;
      
      await tester.pumpWidget(
        QueryClientProvider(
          queryClient: queryClient,
          child: MaterialApp(
            home: HookBuilder(
              builder: (context) {
                final result = useQuery(todosQuery);
                refetchFn = result.refetch;
                
                if (result.isLoading || result.isFetching) {
                  return Column(
                    children: [
                      const CircularProgressIndicator(),
                      Text('Is Fetching: ${result.isFetching}'),
                    ],
                  );
                }
                
                return Column(
                  children: [
                    Text('Todo Count: ${result.data!.length}'),
                    Text('Is Fetching: ${result.isFetching}'),
                  ],
                );
              },
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      
      // Wait for initial fetch
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();
      
      expect(find.text('Todo Count: 10'), findsOneWidget);
      expect(find.text('Is Fetching: false'), findsOneWidget);

      // Trigger refetch
      await refetchFn();
      
      await tester.pump();
      expect(find.text('Is Fetching: true'), findsOneWidget);
      
      // Wait for refetch
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();
      
      expect(find.text('Todo Count: 10'), findsOneWidget);
      expect(find.text('Is Fetching: false'), findsOneWidget);
    });

    testWidgets('should use RefetchOnMount.never when specified', (tester) async {
      // First mount and fetch
      await tester.pumpWidget(
        QueryClientProvider(
          queryClient: queryClient,
          child: MaterialApp(
            home: HookBuilder(
              builder: (context) {
                final result = useQuery(
                  todosQuery,
                  refetchOnMount: RefetchOnMount.never,
                );
                
                if (result.isLoading) {
                  return const CircularProgressIndicator();
                }
                
                return Text('Data: ${result.data != null ? "Loaded" : "Not loaded"}');
              },
            ),
          ),
        ),
      );

      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();
      
      expect(find.text('Data: Loaded'), findsOneWidget);

      // Unmount
      await tester.pumpWidget(Container());
      await tester.pumpAndSettle();

      // Remount - should not refetch due to RefetchOnMount.never
      await tester.pumpWidget(
        QueryClientProvider(
          queryClient: queryClient,
          child: MaterialApp(
            home: HookBuilder(
              builder: (context) {
                final result = useQuery(
                  todosQuery,
                  refetchOnMount: RefetchOnMount.never,
                );
                
                return Text('Data: ${result.data != null ? "Loaded" : "Not loaded"}');
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      
      // Should still have data loaded (no refetch on mount)
      expect(find.text('Data: Loaded'), findsOneWidget);
    });

    testWidgets('should return correct todo data structure', (tester) async {
      await tester.pumpWidget(
        QueryClientProvider(
          queryClient: queryClient,
          child: MaterialApp(
            home: HookBuilder(
              builder: (context) {
                final result = useQuery(todosQuery);
                
                if (result.isLoading) {
                  return const CircularProgressIndicator();
                }
                
                final firstTodo = result.data!.first;
                return Column(
                  children: [
                    Text('ID: ${firstTodo.id}'),
                    Text('Text: ${firstTodo.text}'),
                    Text('Is Done: ${firstTodo.isDone}'),
                  ],
                );
              },
            ),
          ),
        ),
      );

      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();
      
      expect(find.text('ID: 1'), findsOneWidget);
      expect(find.text('Text: Finish homework'), findsOneWidget);
      expect(find.text('Is Done: false'), findsOneWidget);
    });
  });
}