import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fquery/fquery.dart';

class TestData {
  final int id;
  final String name;
  final int value;

  TestData({required this.id, required this.name, required this.value});
}

void main() {
  group('useQuery select feature', () {
    late QueryClient queryClient;

    setUp(() {
      queryClient = QueryClient();
    });

    testWidgets('select transforms data correctly', (tester) async {
      final testData = [
        TestData(id: 1, name: 'Item 1', value: 100),
        TestData(id: 2, name: 'Item 2', value: 200),
        TestData(id: 3, name: 'Item 3', value: 300),
      ];

      await tester.pumpWidget(
        QueryClientProvider(
          queryClient: queryClient,
          child: MaterialApp(
            home: HookBuilder(
              builder: (context) {
                // Test selecting just names
                final names = useQueryWithSelect<List<TestData>, Exception, List<String>>(
                  ['test-data'],
                  () async => testData,
                  select: (data) => data.map((item) => item.name).toList(),
                );

                // Test selecting sum of values
                final sum = useQueryWithSelect<List<TestData>, Exception, int>(
                  ['test-data'],
                  () async => testData,
                  select: (data) => data.fold(0, (sum, item) => sum + item.value),
                );

                // Test without select (backward compatibility)
                final rawData = useQuery<List<TestData>, Exception>(
                  ['test-data'],
                  () async => testData,
                );

                if (names.isLoading || sum.isLoading || rawData.isLoading) {
                  return const CircularProgressIndicator();
                }

                return Column(
                  children: [
                    if (names.data != null)
                      Text('Names: ${names.data!.join(', ')}'),
                    if (sum.data != null)
                      Text('Sum: ${sum.data}'),
                    if (rawData.data != null)
                      Text('Raw count: ${rawData.data!.length}'),
                  ],
                );
              },
            ),
          ),
        ),
      );

      // Wait for data to load
      await tester.pumpAndSettle();

      // Verify transformed data
      expect(find.text('Names: Item 1, Item 2, Item 3'), findsOneWidget);
      expect(find.text('Sum: 600'), findsOneWidget);
      expect(find.text('Raw count: 3'), findsOneWidget);
    });

    testWidgets('select memoizes correctly', (tester) async {
      var selectCallCount = 0;
      final testData = TestData(id: 1, name: 'Test', value: 100);

      await tester.pumpWidget(
        QueryClientProvider(
          queryClient: queryClient,
          child: MaterialApp(
            home: HookBuilder(
              builder: (context) {
                final result = useQueryWithSelect<TestData, Exception, String>(
                  ['memo-test'],
                  () async => testData,
                  select: (data) {
                    selectCallCount++;
                    return data.name.toUpperCase();
                  },
                );

                if (result.isLoading) {
                  return const CircularProgressIndicator();
                }

                return Text(result.data ?? 'No data');
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('TEST'), findsOneWidget);
      expect(selectCallCount, 1);

      // Rebuild widget
      await tester.pump();
      
      // Select should not be called again if data hasn't changed
      expect(selectCallCount, 1);
    });

    testWidgets('QueryBuilder with select works', (tester) async {
      final testData = [
        TestData(id: 1, name: 'Item 1', value: 100),
        TestData(id: 2, name: 'Item 2', value: 200),
      ];

      await tester.pumpWidget(
        QueryClientProvider(
          queryClient: queryClient,
          child: MaterialApp(
            home: QueryBuilder<List<TestData>, Exception, Map<String, dynamic>>(
              ['builder-test'],
              () async => testData,
              select: (data) => {
                'count': data.length,
                'totalValue': data.fold<int>(0, (sum, item) => sum + item.value),
                'names': data.map((item) => item.name).toList(),
              },
              builder: (context, query) {
                if (query.isLoading) {
                  return const CircularProgressIndicator();
                }

                if (query.data != null) {
                  final data = query.data!;
                  return Column(
                    children: [
                      Text('Count: ${data['count']}'),
                      Text('Total: ${data['totalValue']}'),
                      Text('Names: ${(data['names'] as List).join(', ')}'),
                    ],
                  );
                }

                return const Text('No data');
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Count: 2'), findsOneWidget);
      expect(find.text('Total: 300'), findsOneWidget);
      expect(find.text('Names: Item 1, Item 2'), findsOneWidget);
    });
  });
}