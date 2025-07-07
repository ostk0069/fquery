import 'package:basic/models/post.dart';
import 'package:basic/queries/posts_query.dart';
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

  group('postsQuery', () {
    test('should create a query configuration with correct key', () {
      final query = postsQuery;
      expect(query.queryKey, equals(['posts']));
    });

    testWidgets('should fetch posts successfully', (tester) async {
      await tester.pumpWidget(
        QueryClientProvider(
          queryClient: queryClient,
          child: MaterialApp(
            home: HookBuilder(
              builder: (context) {
                final result = useQuery(postsQuery);
                
                if (result.isLoading) {
                  return const CircularProgressIndicator();
                }
                
                if (result.error != null) {
                  return Text('Error: ${result.error}');
                }
                
                return Column(
                  children: [
                    Text('Posts count: ${result.data!.length}'),
                    if (result.data!.isNotEmpty) Text(result.data!.first.title),
                  ],
                );
              },
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      
      // Wait for API call and mock delay
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();
      
      // Verify that posts were fetched (JSONPlaceholder returns 100 posts)
      expect(find.textContaining('Posts count:'), findsOneWidget);
    });

    testWidgets('should respect enabled option', (tester) async {
      await tester.pumpWidget(
        QueryClientProvider(
          queryClient: queryClient,
          child: MaterialApp(
            home: HookBuilder(
              builder: (context) {
                final result = useQuery(
                  postsQuery,
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

    testWidgets('should support refetch', (tester) async {
      late Future<void> Function() refetchFn;

      await tester.pumpWidget(
        QueryClientProvider(
          queryClient: queryClient,
          child: MaterialApp(
            home: HookBuilder(
              builder: (context) {
                final result = useQuery(postsQuery);
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
                    Text('Posts count: ${result.data!.length}'),
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
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();
      
      expect(find.textContaining('Posts count:'), findsOneWidget);
      expect(find.text('Is Fetching: false'), findsOneWidget);

      // Trigger refetch
      await refetchFn();

      await tester.pump();
      expect(find.text('Is Fetching: true'), findsOneWidget);

      // Wait for refetch
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();
      
      expect(find.textContaining('Posts count:'), findsOneWidget);
      expect(find.text('Is Fetching: false'), findsOneWidget);
    });
  });
}