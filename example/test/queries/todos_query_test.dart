import 'package:basic/models/todos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fquery/fquery.dart';

import '../helpers/query_test_helpers.dart';

void main() {
  late QueryClient queryClient;
  late QueryConfig<List<Todo>> testTodosQuery;

  setUp(() {
    queryClient = QueryClient();
    testTodosQuery = createQuery<List<Todo>>(
      ['todos'],
      () async {
        // Return mock data directly instead of using TodosAPI
        await Future.delayed(const Duration(milliseconds: 100));

        return [
          Todo(id: 1, text: 'Finish homework'),
          Todo(id: 2, text: 'Buy groceries'),
          Todo(id: 3, text: 'Call mom'),
          Todo(id: 4, text: 'Go for a run'),
          Todo(id: 5, text: 'Read a book'),
          Todo(id: 6, text: 'Write an article'),
          Todo(id: 7, text: 'Cook dinner'),
          Todo(id: 8, text: 'Attend meeting'),
          Todo(id: 9, text: 'Practice guitar'),
          Todo(id: 10, text: 'Plan vacation'),
        ];
      },
    );
  });

  tearDown(() {
    // QueryClient doesn't have dispose method
  });

  group('todosQuery', () {
    testWidgets('should fetch todos successfully', (tester) async {
      await tester.pumpWidget(
        QueryTestHelper.buildTestApp(
          queryClient: queryClient,
          child: QueryTestHelper.buildQueryTest(
            query: testTodosQuery,
            builder: (context, result) {
              return result.toTestWidget(
                data: (List<Todo> todos) => Column(
                  children: [
                    Text('Todo count: ${todos.length}'),
                    if (todos.isNotEmpty) Text(todos.first.text),
                  ],
                ),
              );
            },
          ),
        ),
      );

      QueryTestHelper.expectLoading(tester);

      // Wait for mock delay
      await QueryTestHelper.waitForQuery(tester,
          delay: const Duration(milliseconds: 200));

      // Verify todos are displayed
      expect(find.text('Todo count: 10'), findsOneWidget);
      expect(find.text('Finish homework'), findsOneWidget);
    });

    testWidgets('should respect enabled option', skip: true, (tester) async {
      await tester.pumpWidget(
        QueryTestHelper.buildTestApp(
          queryClient: queryClient,
          child: QueryTestHelper.buildQueryTest(
            query: testTodosQuery,
            options: const QueryOptions(enabled: false),
            builder: (context, result) {
              return Column(
                children: [
                  Text('Is Loading: ${result.isLoading}'),
                  Text('Has Data: ${result.data != null}'),
                ],
              );
            },
          ),
        ),
      );

      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.text('Is Loading: false'), findsOneWidget);
      expect(find.text('Has Data: false'), findsOneWidget);
    });

    testWidgets('should handle refetch', (tester) async {
      late Future<void> Function() refetchFn;

      await tester.pumpWidget(
        QueryTestHelper.buildTestApp(
          queryClient: queryClient,
          child: QueryTestHelper.buildRefetchTest(
            query: testTodosQuery,
            builder: (context, result, setRefetch) {
              refetchFn = () => result.refetch();

              if (result.isLoading || result.isFetching) {
                return Column(
                  children: [
                    const CircularProgressIndicator(),
                    Text('Is Fetching: ${result.isFetching}'),
                  ],
                );
              }

              final todos = result.data as List<Todo>;
              return Column(
                children: [
                  Text('Todo Count: ${todos.length}'),
                  Text('Is Fetching: ${result.isFetching}'),
                ],
              );
            },
          ),
        ),
      );

      QueryTestHelper.expectLoading(tester);

      // Wait for initial fetch
      await QueryTestHelper.waitForQuery(tester,
          delay: const Duration(milliseconds: 200));

      expect(find.text('Todo Count: 10'), findsOneWidget);
      expect(find.text('Is Fetching: false'), findsOneWidget);

      // Trigger refetch
      await refetchFn();

      await tester.pump();
      expect(find.text('Is Fetching: true'), findsOneWidget);

      // Wait for refetch
      await QueryTestHelper.waitForQuery(tester,
          delay: const Duration(milliseconds: 200));

      expect(find.text('Todo Count: 10'), findsOneWidget);
      expect(find.text('Is Fetching: false'), findsOneWidget);
    });

    testWidgets('should use RefetchOnMount.never when specified',
        (tester) async {
      // First mount and fetch
      await tester.pumpWidget(
        QueryTestHelper.buildTestApp(
          queryClient: queryClient,
          child: QueryTestHelper.buildQueryTest(
            query: testTodosQuery,
            options: const QueryOptions(refetchOnMount: RefetchOnMount.never),
            builder: (context, result) {
              return result.toTestWidget(
                data: (_) => const Text('Data: Loaded'),
                loading: () => const CircularProgressIndicator(),
              );
            },
          ),
        ),
      );

      await QueryTestHelper.waitForQuery(tester,
          delay: const Duration(milliseconds: 200));

      expect(find.text('Data: Loaded'), findsOneWidget);

      // Unmount
      await tester.pumpWidget(Container());
      await tester.pumpAndSettle();

      // Remount - should not refetch due to RefetchOnMount.never
      await tester.pumpWidget(
        QueryTestHelper.buildTestApp(
          queryClient: queryClient,
          child: QueryTestHelper.buildQueryTest(
            query: testTodosQuery,
            options: const QueryOptions(refetchOnMount: RefetchOnMount.never),
            builder: (context, result) {
              return Text(
                  'Data: ${result.data != null ? "Loaded" : "Not loaded"}');
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should still have data loaded (no refetch on mount)
      expect(find.text('Data: Loaded'), findsOneWidget);
    });

    testWidgets('should return correct todo data structure', (tester) async {
      await tester.pumpWidget(
        QueryTestHelper.buildTestApp(
          queryClient: queryClient,
          child: QueryTestHelper.buildQueryTest(
            query: testTodosQuery,
            builder: (context, result) {
              return result.toTestWidget(
                data: (List<Todo> todos) {
                  final firstTodo = todos.first;
                  return Column(
                    children: [
                      Text('ID: ${firstTodo.id}'),
                      Text('Text: ${firstTodo.text}'),
                      Text('Is Done: ${firstTodo.isDone}'),
                    ],
                  );
                },
              );
            },
          ),
        ),
      );

      await QueryTestHelper.waitForQuery(tester,
          delay: const Duration(milliseconds: 200));

      expect(find.text('ID: 1'), findsOneWidget);
      expect(find.text('Text: Finish homework'), findsOneWidget);
      expect(find.text('Is Done: false'), findsOneWidget);
    });
  });
}
