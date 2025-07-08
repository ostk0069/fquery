import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fquery/fquery.dart';

import 'query_test_helpers.dart';

/// Configuration for a query test suite
class QueryTestConfig<T> {
  final String groupName;
  final QueryConfig<T> query;
  final String countLabel;
  final int expectedCount;
  final String firstItemText;
  final Widget Function(T data) buildDataWidget;
  final Widget Function(T data) buildRefetchWidget;
  final List<QueryTestCase<T>>? additionalTests;

  const QueryTestConfig({
    required this.groupName,
    required this.query,
    required this.countLabel,
    required this.expectedCount,
    required this.firstItemText,
    required this.buildDataWidget,
    required this.buildRefetchWidget,
    this.additionalTests,
  });
}

/// Individual test case configuration
class QueryTestCase<T> {
  final String name;
  final Future<void> Function(WidgetTester tester, QueryClient queryClient) test;
  final bool skip;

  const QueryTestCase({
    required this.name,
    required this.test,
    this.skip = false,
  });
}

/// Generate a complete test suite for a query
void generateQueryTestSuite<T>(QueryTestConfig<T> config) {
  late QueryClient queryClient;

  setUp(() {
    queryClient = QueryClient();
  });

  tearDown(() {
    // QueryClient doesn't have dispose method
  });

  group(config.groupName, () {
    testWidgets('should fetch ${config.groupName} successfully', (tester) async {
      await tester.pumpWidget(
        QueryTestHelper.buildTestApp(
          queryClient: queryClient,
          child: QueryTestHelper.buildQueryTest(
            query: config.query,
            builder: (context, result) {
              return result.toTestWidget(
                data: config.buildDataWidget,
              );
            },
          ),
        ),
      );

      QueryTestHelper.expectLoading(tester);

      // Wait for mock delay
      await QueryTestHelper.waitForQuery(tester,
          delay: const Duration(milliseconds: 200));

      // Verify data was fetched
      expect(find.text('${config.countLabel}: ${config.expectedCount}'), findsOneWidget);
      expect(find.text(config.firstItemText), findsOneWidget);
    });

    testWidgets('should respect enabled option', skip: true, (tester) async {
      await tester.pumpWidget(
        QueryTestHelper.buildTestApp(
          queryClient: queryClient,
          child: QueryTestHelper.buildQueryTest(
            query: config.query,
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

    testWidgets('should support refetch', (tester) async {
      late Future<void> Function() refetchFn;

      await tester.pumpWidget(
        QueryTestHelper.buildTestApp(
          queryClient: queryClient,
          child: QueryTestHelper.buildRefetchTest(
            query: config.query,
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

              return config.buildRefetchWidget(result.data as T);
            },
          ),
        ),
      );

      QueryTestHelper.expectLoading(tester);

      // Wait for initial fetch
      await QueryTestHelper.waitForQuery(tester,
          delay: const Duration(milliseconds: 200));

      expect(find.text('${config.countLabel}: ${config.expectedCount}'), findsOneWidget);
      expect(find.text('Is Fetching: false'), findsOneWidget);

      // Trigger refetch
      await refetchFn();

      await tester.pump();
      expect(find.text('Is Fetching: true'), findsOneWidget);

      // Wait for refetch
      await QueryTestHelper.waitForQuery(tester,
          delay: const Duration(milliseconds: 200));

      expect(find.text('${config.countLabel}: ${config.expectedCount}'), findsOneWidget);
      expect(find.text('Is Fetching: false'), findsOneWidget);
    });

    // Add any additional tests
    if (config.additionalTests != null) {
      for (final testCase in config.additionalTests!) {
        testWidgets(testCase.name, skip: testCase.skip, (tester) async {
          await testCase.test(tester, queryClient);
        });
      }
    }
  });
}